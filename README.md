# 🎨 SimplexNoise: 2D / 3D Simplex Noise & fBm Library for MoonBit

[English](https://github.com/ZSeanYves/SimplexNoise/blob/main/README.md) | [简体中文](https://github.com/ZSeanYves/SimplexNoise/blob/main/README_zh_CN.md)

[![Build Status](https://img.shields.io/github/actions/workflow/status/ZSeanYves/SimplexNoise/simplex_noise_ci.yml)](https://github.com/ZSeanYves/SimplexNoise/actions)
[![License](https://img.shields.io/github/license/ZSeanYves/SimplexNoise)](LICENSE)

**SimplexNoise** is a lightweight MoonBit noise library supporting 2D and 3D Simplex noise, multi-octave fractal Brownian motion (fBm) noise, grayscale and color image output. It is suitable for terrain generation, clouds, procedural textures, volumetric noise visualization, and educational use.

---

## 🚀 Features

* **2D & 3D Simplex Noise** with seed control
* **Multi-Octave fBm Noise**, configurable octaves, persistence, lacunarity
* **Grayscale & Color PNG Output**
* **3D Single Slice and Batch Slice Output**
* **Customizable Color Mapping**
* **Clean and Extensible MoonBit Design**

---

## 📦 Installation

```bash
moon add ZSeanYves/SimplexNoise
```

Or manually in `moon.mod.json`:

```json
"import": ["ZSeanYves/SimplexNoise"]
```

---

## 🎨 Basic Usage Examples

### 2D Grayscale Noise Image

```moonbit
let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise(42)
@ZSeanYves/SimplexNoise.generate_and_save_noise_image("./noise.png", 256, 256, 0.05, 42, grads)
//return Bool，others are as well
```

### 2D Color fBm Noise Image

```moonbit
let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(5, 0.5, 2.0, 0.03)
let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise(123)
@ZSeanYves/SimplexNoise.generate_and_save_fbm_image_color("./fbm_color.png", 256, 256, 123, grads, config)
```

### 3D Noise Single Slice Image

```moonbit
let (_, grads3d) = @ZSeanYves/SimplexNoise.create_simplex_noise3d(42)
@ZSeanYves/SimplexNoise.generate_and_save_noise3d_image("./slice.png", 256, 256, 0.05, 0.3, 42, grads3d)
```

### 3D Batch Slice Output

```moonbit
@ZSeanYves/SimplexNoise.generate_3d_slices("./slices", 128, 128, 0.05, 42, grads3d, 20)
```

---

## 📘 API Overview

### 2D Image Output

| Function                              | Description                               |
| ------------------------------------- | ----------------------------------------- |
| `generate_and_save_noise_image`       | Generate 2D grayscale Simplex noise image |
| `generate_and_save_fbm_image`         | Generate 2D grayscale fBm noise image     |
| `generate_and_save_noise_image_color` | Generate 2D color Simplex noise image     |
| `generate_and_save_fbm_image_color`   | Generate 2D color fBm noise image         |

### 3D Slice Output

| Function                                | Description                                  |
| --------------------------------------- | -------------------------------------------- |
| `generate_and_save_noise3d_image`       | Generate 3D single slice grayscale image     |
| `generate_and_save_fbm3d_image`         | Generate 3D fBm single slice grayscale image |
| `generate_and_save_noise3d_image_color` | Generate 3D single slice color image         |
| `generate_and_save_fbm3d_image_color`   | Generate 3D fBm single slice color image     |
| `generate_3d_slices`                    | Batch generate 3D grayscale slices           |
| `generate_fbm3d_slices`                 | Batch generate 3D fBm grayscale slices       |
| `generate_3d_slices_color`              | Batch generate 3D color slices               |
| `generate_fbm3d_slices_color`           | Batch generate 3D fBm color slices           |

---

## 🎛️ Configuration Options

| Option            | Description                                      | Function to Set                                                            |
| ----------------- | ------------------------------------------------ | -------------------------------------------------------------------------- |
| **Seed**          | Controls permutation table randomness            | `create_simplex_noise(seed)` (2D) <br> `create_simplex_noise3d(seed)` (3D) |
| **NoiseConfig**   | Controls octaves, persistence, lacunarity, scale | `new_NoiseConfig(octaves, persistence, lacunarity, scale)`                 |
| **Color Mapping** | Defines color gradient mapping                   | Modify `noise_to_color(val: Float) -> @color.RGBA`                         |

---

## 📂 Project Structure

```
SimplexNoise/
├── src/
│   ├── fbm.mbt                     # 2D fBm noise logic
│   ├── fbm3d.mbt                   # 3D fBm noise logic
│   ├── image_gen.mbt               # Image output (2D & 3D)
│   ├── noise2d.mbt                 # 2D Simplex noise
│   ├── noise3d.mbt                 # 3D Simplex noise
│   ├── random.mbt                  # Seed-based permutation table
│   ├── simplex_noise.mbt           # Public API wrapper
│   ├── simplex_noise_tests.mbt     # Unit tests
│   ├── SimplexNoise.mbti           # Public interface & config
│   └── moon.pkg.json               # Package metadata
├── examples/                       # Example output images
├── LICENSE
└── README.md
```

---

## 🧪 Testing

Run full test suite:

```bash
moon test -p ZSeanYves/simplexnoise
```

---

## ⚡ Future Work

* 4D noise support
* Tileable noise & domain warping extensions
* Analytic derivatives (normal map generation)

---

## 📜 License

MIT License. See [LICENSE](./LICENSE) for details.

---
