#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
unset PYENV_VERSION

BENCH_DIR="benchmarks"
BENCHMARKS=("$BENCH_DIR"/*.py)
SUMMARY_MODE=false
SUMMARY_FILE="results/summary.md"

# ==========================================================
# Parse CLI arguments
# ==========================================================
parse_args() {
    for arg in "$@"; do
        case $arg in
            --summary-table)
                SUMMARY_MODE=true
                shift
                ;;
            *)
                echo "Unknown option: $arg"
                echo "Usage: ./run.sh [--summary-table]"
                exit 1
                ;;
        esac
    done
}

# ==========================================================
# Detect installed Python versions via pyenv
# ==========================================================
detect_versions() {
    local raw_versions
    raw_versions=$(pyenv versions --bare | grep -vE 'system|dev|envs' | tr -d '*')

    if [[ -z "$raw_versions" ]]; then
        echo "❌ No valid Python versions found in pyenv!"
        exit 1
    fi

    VERSIONS=($raw_versions)
    echo "📦 Detected Python versions:"
    for version in "${VERSIONS[@]}"; do
        echo " - $version"
    done
    echo
}

# ==========================================================
# Ensure dependencies for each Python version via uv
# ==========================================================
ensure_dependencies() {
    local version="$1"
    echo "🔧 Ensuring dependencies for Python $version"
    PYENV_VERSION="$version" uv sync --all-extras --dev --locked 2>/dev/null || {
        echo "⚠️  uv sync failed for Python $version — attempting without lock"
        PYENV_VERSION="$version" uv sync --all-extras --dev || true
    }
}

# ==========================================================
# Execute a single benchmark for one Python version
# ==========================================================
run_benchmarks_for_version() {
    local version="$1"
    local benchmark="$2"

    echo
    echo "🐍 Python $version"
    echo "---------------------------------------"

    if ! pyenv prefix "$version" &>/dev/null; then
        echo "⚠️  Skipping invalid or unavailable version: $version"
        return
    fi

    ensure_dependencies "$version"

    echo "▶️  Using Python $version"

    # Run within UV's managed environment
    local output
    output=$(PYENV_VERSION="$version" uv run --python "$version" python "$benchmark" 2>&1 | tee /dev/tty || true)

    local py_version
    py_version=$(echo "$output" | grep -E '^Python:' | awk '{print $2}')
    local metrics
    metrics=$(echo "$output" | grep -E '^[A-Z].*: [0-9]' | grep -v '^Benchmark:' | grep -v '^Python:')

    local row="| $py_version"
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        local key val
        key=$(echo "$line" | cut -d':' -f1 | tr -d '\r')
        val=$(echo "$line" | cut -d':' -f2 | xargs)
        approach_names["$key"]=1
        row="$row | $val"
    done <<< "$metrics"
    row="$row |"
    all_rows+=("$row")

    echo "---------------------------------------"
}

# ==========================================================
# Write Markdown summary for a single benchmark
# ==========================================================
write_summary() {
    local bench_name="$1"

    echo "## 🧩 $bench_name" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"

    local header="| Python Version"
    for key in "${!approach_names[@]}"; do
        header="$header | ${key} (s)"
    done
    echo "$header |" >> "$SUMMARY_FILE"

    local sep="|----------------"
    for _ in "${!approach_names[@]}"; do
        sep="$sep|----------------"
    done
    echo "$sep|" >> "$SUMMARY_FILE"

    for row in "${all_rows[@]}"; do
        echo "$row" >> "$SUMMARY_FILE"
    done
    echo "" >> "$SUMMARY_FILE"
}

# ==========================================================
# Main benchmark runner
# ==========================================================
run_all_benchmarks() {
    for benchmark in "${BENCHMARKS[@]}"; do
        local bench_name
        bench_name=$(basename "$benchmark")
        echo
        echo "🚀 Benchmark file: $bench_name"
        echo "======================================="

        declare -a all_rows=()
        declare -A approach_names=()

        for version in "${VERSIONS[@]}"; do
            run_benchmarks_for_version "$version" "$benchmark"
        done

        if [[ "$SUMMARY_MODE" == true ]]; then
            write_summary "$bench_name"
        fi

        echo "======================================="
        echo "✅ Finished benchmark: $bench_name"
        echo "======================================="
    done
}

# ==========================================================
# Initialization
# ==========================================================
initialize_environment() {
    clear
    echo "======================================="
    echo "========= Running Benchmarks =========="
    echo "======================================="

    if [[ ! -d "$BENCH_DIR" ]]; then
        echo "❌ Benchmarks directory not found: $(pwd)/$BENCH_DIR"
        exit 1
    fi

    if [[ ${#BENCHMARKS[@]} -eq 0 ]]; then
        echo "❌ No benchmark scripts found in $(pwd)/$BENCH_DIR"
        exit 1
    fi

    if [[ "$SUMMARY_MODE" == true ]]; then
        mkdir -p results
        echo "# 🧪 Benchmark Summary" > "$SUMMARY_FILE"
        echo "" >> "$SUMMARY_FILE"
    fi
}

# ==========================================================
# Cleanup
# ==========================================================
cleanup() {
    pyenv shell --unset || true
    unset PYENV_VERSION
    echo
    echo "======================================="
    echo "======= All Benchmarks Complete ======="
    echo "======================================="

    if [[ "$SUMMARY_MODE" == true ]]; then
        echo
        echo "📊 Summary tables saved to: $SUMMARY_FILE"
        echo
    fi
}

# ==========================================================
# Main entry
# ==========================================================
main() {
    parse_args "$@"
    detect_versions
    initialize_environment
    run_all_benchmarks
    cleanup
}

main "$@"
