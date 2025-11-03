# 🧪 Python Benchmark Suite

A reproducible, extensible framework for benchmarking **Python runtime behavior** across multiple interpreter versions managed by [pyenv](https://github.com/pyenv/pyenv).

This suite allows engineers to **measure performance differences** (e.g., property access vs. direct attribute access, dataclass instantiation, etc.) across versions such as Python 3.9 → 3.14, with a focus on reproducibility and isolation.

---

## ⚙️ Features

- 🔍 **Automatic version detection** — dynamically discovers all Python interpreters installed via `pyenv`.
- 📂 **Structured benchmarks directory** — executes all `.py` scripts in `benchmarks/`.
- 🧱 **Isolated execution** — each benchmark runs independently for every interpreter.
- 🧩 **Automatic discovery** — no need to register benchmarks manually.
- 📈 **Version-to-version comparison** — visualize runtime differences across interpreters.

---

## 📂 Repository Structure

```
python_benchmark/
├── benchmarks/
│   └── property_benchmark.py    # Current benchmark
├── run.sh                       # Benchmark orchestrator
└── README.md                    # Documentation
```

---

## 🧰 Requirements

- **Linux / macOS**
- [pyenv](https://github.com/pyenv/pyenv) installed and configured
  ```bash
  curl https://pyenv.run | bash
  ```
- One or more Python interpreters installed:
  ```bash
  pyenv install 3.9.21
  pyenv install 3.10.14
  pyenv install 3.12.11
  pyenv install 3.13.4
  pyenv install 3.14.0b2t
  ```

---

## 🚀 Running Benchmarks

1. Ensure `pyenv` is active in your shell:
   ```bash
   eval "$(pyenv init -)"
   ```

2. Run the full suite:
   ```bash
   ./run.sh
   ```

3. The script will:
   - Detect every installed Python version.
   - Execute all benchmark files in the `benchmarks/` directory.
   - Display results for each interpreter independently.

Example output:

```
🚀 Benchmark file: property_benchmark.py
🐍 Python 3.12.11
---------------------------------------
Direct attribute: 0.26
Property access: 0.71
---------------------------------------
✅ Finished benchmark: property_benchmark.py
```

---

## 📊 Results Summary (Template)

| Python Version | Benchmark File           | Metric / Description           | Result (s) | Notes |
|----------------|--------------------------|--------------------------------|-------------|-------|
| 3.9.21         | property_benchmark.py     | Property access (10M calls)    | 0.70        |       |
| 3.10.14        | property_benchmark.py     | Property access (10M calls)    | 0.68        |       |
| 3.12.11        | property_benchmark.py     | Property access (10M calls)    | 0.65        | Fastest |
| 3.14.0b2t      | property_benchmark.py     | Property access (10M calls)    | 0.64        | Beta version |
| ...            | ...                      | ...                            | ...         | ...   |

> You can extend this table after each run by copying values from the terminal or logs.

---

## 🧠 Design Philosophy

This suite prioritizes **clarity, repeatability, and isolation**:

- Every benchmark executes in a clean, self-contained environment.
- `pyenv` ensures consistent interpreter selection and reproducibility.
- The design encourages adding benchmarks without modifying orchestration code.

---

## 🧾 License

Licensed under the **MIT License**.  
See [`LICENSE`](LICENSE) for details.
