# 🎨 SimplexNoise: 2D Simplex Noise & fBm Library for MoonBit

[English](https://github.com/ZSeanYves/SimplexNoise/blob/main/README.md) | [简体中文](https://github.com/ZSeanYves/SimplexNoise/blob/main/README_zh_CN.md)

[![Build Status](https://img.shields.io/github/actions/workflow/status/ZSeanYves/SimplexNoise/simplex_noise_ci.yml)](https://github.com/ZSeanYves/SimplexNoise/actions)
[![License](https://img.shields.io/github/license/ZSeanYves/SimplexNoise)](LICENSE)

**SimplexNoise** is a lightweight, procedural noise library for MoonBit supporting 2D Simplex Noise, multi-octave fractal Brownian motion (fBm), and both grayscale and color visualizations. Ideal for terrain, clouds, texture generation, and educational use.

---

## 🚀 Features

* **2D Simplex Noise** with configurable seed
* **Multi-Octave fBm** (octaves, persistence, lacunarity)
* **Grayscale & Color PNG Output**
* **Customizable Color Mapping**
* **Clear, modular MoonBit design**

---

## 📦 Installation

```bash
moon add ZSeanYves/SimplexNoise
```

Or manually edit `moon.mod.json`:

```json
"import": ["ZSeanYves/SimplexNoise"]
```

---

## 🎨 Basic Usage

### Grayscale Noise Image

```moonbit
let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise(42)
@ZSeanYves/SimplexNoise.generate_and_save_noise_image("./noise.png", 256, 256, 0.05, 42, grads) 
// return Bool 
//The return values of such image-saving functions are all of type Bool.
```

### Color fBm Image

```moonbit
let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(5, 0.5, 2.0, 0.03)
let (_, grads) = create_simplex_noise(123)
@ZSeanYves/SimplexNoise.generate_and_save_fbm_image_color("./fbm_color.png", 256, 256, 123, grads, config)
```

---

## 📘 API Overview

### Simple Noise Functions

| Function                              | Description                 |
| ------------------------------------- | --------------------------- |
| `generate_and_save_noise_image`       | Grayscale Simplex Noise PNG |
| `generate_and_save_noise_image_color` | Color Simplex Noise PNG     |

### fBm (Multi-Octave) Functions

| Function                            | Description             |
| ----------------------------------- | ----------------------- |
| `generate_and_save_fbm_image`       | Grayscale fBm Noise PNG |
| `generate_and_save_fbm_image_color` | Color fBm Noise PNG     |

---

## 🎛️ Customization

* **Seed**: Controls randomness of permutation table
* **NoiseConfig**: Octaves, persistence, lacunarity, scale
* **Color Mapping**: Modify `noise_to_color` to define custom gradients

---

## 📂 Project Structure

```
SimplexNoise/
├── src/
│   ├── fbm.mbt                   # fBm noise logic
│   ├── image_gen.mbt             # Image output (gray + color)
│   ├── noise2d.mbt               # Core Simplex 2D noise
│   ├── random.mbt                # Seed-based permutation table
│   ├── simplex_noise.mbt         # Public API wrapper
│   ├── simplex_noise_tests.mbt   # Unit tests
│   ├── SimplexNoise.mbti         # Public interface + config
│   └── moon.pkg.json             # Package metadata
├── examples/                     # Example output images
├── LICENSE
└── README.md
```

---

## 🧪 Testing

Run all tests:

```bash
moon test -p ZSeanYves/simplexnoise
```

---

## ⚡ Future Work

* 3D / 4D Noise extensions
* Tileable and Domain-Warped Noise
* Analytic Derivatives for normal map generation

---

## 📜 License

MIT License. See [LICENSE](./LICENSE) for full details.

---
