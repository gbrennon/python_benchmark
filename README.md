# 🧪 Python Benchmark Suite

This repository provides a reproducible framework for benchmarking Python language behavior and runtime performance across **multiple interpreter versions** managed via [pyenv](https://github.com/pyenv/pyenv).

It is designed for senior engineers and performance-minded developers who need to **quantify differences in execution cost** (e.g., attribute access, function call overhead, dataclass vs. property performance, etc.) between Python releases.

---

## ⚙️ Features

- 🔍 **Version-to-version comparison** — run the same benchmark across multiple Python versions.
- 🧩 **Automatic benchmark discovery** — any file inside `benchmarks/` ending with `_benchmark.py` is picked up automatically.
- 🧱 **Isolated execution** — each benchmark runs independently for every interpreter.
- 📈 **Structured output** — generates Markdown summary tables across Python versions and approaches.
- 🧰 **Template generator** — create new benchmarks quickly using `./new_benchmark.sh`.

---

## 📂 Repository Structure

```
python_benchmark/
├── run.sh             # Benchmark orchestrator
├── new_benchmark.sh   # Template generator for new benchmarks
├── benchmarks/        # Your benchmark scripts (*.py)
└── results/           # Auto-generated benchmark results (gitignored)
```

Each Python script placed inside `benchmarks/` with the suffix `_benchmark.py` will be automatically discovered and executed by `run.sh`.

You can **implement any benchmark you want** — whether testing a micro-optimization, comparing architectural patterns, or evaluating performance between frameworks. As long as the file prints labeled results (e.g., `Approach A: <time>`), it will be included in the generated summary tables.

---

## 🧰 Requirements

- **Linux / macOS**
- **pyenv** installed and configured  
  ```bash
  curl https://pyenv.run | bash
  ```
- Install a few Python versions to test:
  ```bash
  pyenv install 3.9.21
  pyenv install 3.10.14
  pyenv install 3.12.11
  pyenv install 3.13.4
  pyenv install 3.14.0
  ```

---

## 🚀 Running Benchmarks

To run all benchmarks sequentially across all Python versions:

```bash
./run.sh
```

To run benchmarks and **generate a Markdown summary report**:

```bash
./run.sh --summary-table
```

This will produce a file at:

```
results/summary.md
```

Each benchmark produces its own section in that file.

---

## 🧩 Creating a New Benchmark

You can generate a new benchmark template quickly:

```bash
./new_benchmark.sh dict_vs_list
```

This creates a file at `benchmarks/dict_vs_list_benchmark.py` pre-populated with a minimal benchmark template using Python’s `timeit` module.

After generation, you can modify it to benchmark whatever behavior, library, or architectural pattern you want to measure — for example:

- Comparing direct vs. property access.
- Comparing dataclass instantiation vs. manual `__init__`.
- Comparing service-layer orchestration vs. direct domain calls.

As long as your benchmark prints labeled times in the format:

```
Approach Name: <seconds>
```

the results will appear correctly in the final summary.

---

## 📊 Example Results

When you run the suite with `--summary-table`, all results are saved to:

```
results/summary.md
```

Each benchmark script produces a **separate Markdown table** showing all Python versions as rows and each tested approach as a column.

### Example 1 — `property_benchmark.py`

| Python Version | Property Access (s) | Direct Access (s) |
|----------------|--------------------:|------------------:|
| 3.9.21         | 0.287390            | 0.877322          |
| 3.14.0         | 0.126226            | 0.283366          |

➡️ In this benchmark, `Property Access` shows a **~3× speed improvement** between Python 3.9 and 3.14, indicating significant runtime optimizations in attribute handling.

---

### Example 2 — `json_vs_pydantic_validation_benchmark.py`

| Python Version | Dataclass Validation (s) | JSON Parse Only (s) | Pydantic Validation (s) |
|----------------|--------------------------:|---------------------:|-------------------------:|
| 3.9.21         | 0.210205                  | 0.286122             | 0.132171                 |
| 3.14.0         | 0.184083                  | 0.238300             | 0.128887                 |

➡️ Here, both `Dataclass Validation` and `Pydantic Validation` exhibit **minor runtime gains**, while JSON parsing overhead remains relatively stable across versions.

---

## 🧠 Design Philosophy

This project embodies **clarity, reproducibility, and isolation**:

- Every benchmark runs independently of global state.
- pyenv ensures consistent interpreter environments.
- Bash automation allows exact replication of runs across machines.
- Dependencies are managed reproducibly via `uv` and `pyproject.toml`.

---

## 🧾 License

This project is licensed under the **MIT License**.  
See [`LICENSE`](LICENSE) for details.
