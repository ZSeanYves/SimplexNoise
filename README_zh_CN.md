# 🎨 SimplexNoise：MoonBit 的 2D / 3D / 4D Simplex 噪声与 fBm 噪声库

[English](https://github.com/ZSeanYves/SimplexNoise/blob/main/README.md) | [简体中文](https://github.com/ZSeanYves/SimplexNoise/blob/main/README_zh_CN.md)

[![Build Status](https://img.shields.io/github/actions/workflow/status/ZSeanYves/SimplexNoise/simplex_noise_ci.yml)](https://github.com/ZSeanYves/SimplexNoise/actions)
[![License](https://img.shields.io/github/license/ZSeanYves/SimplexNoise)](LICENSE)

**SimplexNoise** 是一个轻量级 MoonBit 噪声生成库，支持 2D / 3D / 4D Simplex 噪声，多谋段 fBm (fractal Brownian motion) 扩展，可生成灰度图和颜色图应用于地形、云图、终端纹理、动态纹理模拟等场景。

---

## 🚀 功能特性

* 支持 **2D / 3D / 4D Simplex 噪声**，可设置种子
* **fBm 多层噪声**，支持谋段数，持续系数和间隔系数
* 输出 **灰度 / 颜色 PNG 图像**
* 支持 **3D / 4D 切片生成和批量生成**
* 可自定义 **颜色映射规则**
* 以 MoonBit 编程为根基，清晰且易于扩展

---

## 📦 安装

```bash
moon add ZSeanYves/SimplexNoise
```

或手动添加到 `moon.mod.json`文件：

```json
"import": ["ZSeanYves/SimplexNoise"]
```

---

## 🎨 基础示例

### 生成2D 灰度噪声图

```moonbit
let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise(42)
@ZSeanYves/SimplexNoise.generate_and_save_noise_image("./noise.png", 256, 256, 0.05, 42, grads)
```

### 生成2D fBm 颜色噪声图

```moonbit
let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(5, 0.5, 2.0, 0.03)
let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise(123)
@ZSeanYves/SimplexNoise.generate_and_save_fbm_image_color("./fbm_color.png", 256, 256, 123, grads, config)
```

### 生成3D 切片灰度图

```moonbit
let (_, grads3d) = @ZSeanYves/SimplexNoise.create_simplex_noise3d(42)
@ZSeanYves/SimplexNoise.generate_and_save_noise3d_image("./slice.png", 256, 256, 0.05, 0.3, 42, grads3d)
```

### 批量生成3D 切片

```moonbit
@ZSeanYves/SimplexNoise.generate_3d_slices("./slices", 128, 128, 0.05, 42, grads3d, 20)
```

---

## 📘 公共 API 介绍

### 2D 噪声生成

| 函数                                    | 描述                  |
| ------------------------------------- | ------------------- |
| `generate_and_save_noise_image`       | 生成2D 灰度 Simplex 噪声图 |
| `generate_and_save_fbm_image`         | 生成2D fBm 灰度噪声图      |
| `generate_and_save_noise_image_color` | 生成2D 颜色 Simplex 噪声图 |
| `generate_and_save_fbm_image_color`   | 生成2D 颜色 fBm 噪声图     |

### 3D / 4D 切片生成

| 函数                                | 描述             |
| --------------------------------- | -------------- |
| `generate_and_save_noise3d_image` | 生成3D 灰度切片图     |
| `generate_and_save_fbm3d_image`   | 生成3D fBm 灰度切片图 |
| `generate_and_save_noise4d_image` | 生成4D 灰度切片图     |
| `generate_and_save_fbm4d_image`   | 生成4D fBm 灰度切片图 |
| `generate_3d_slices`              | 批量生成3D 灰度切片    |
| `generate_fbm3d_slices`           | 批量生成3D fBm 切片  |

---

## ⚙️ 参数含义

| 参数                | 类型              | 含义                         |
| ----------------- | --------------- | -------------------------- |
| `width`, `height` | `Int`           | 图像的宽高                      |
| `scale`           | `Float`         | 噪声线程纯应用的频率系数               |
| `z`, `w`          | `Float`         | 3D/4D 切片位置                 |
| `seed`            | `Int`           | 随机种子，控制结果不同                |
| `grads`           | `Array[Vector]` | 描述噪声向量表                    |
| `config`          | `NoiseConfig`   | fBm 配置，包括 octaves/持续/间隔/频率 |

---

## 📂 项目目录

```
SimplexNoise/
├── src/
│   ├── noise2d.mbt                # 2D Simplex 噪声核心
│   ├── noise3d.mbt                # 3D Simplex 噪声
│   ├── fbm.mbt                    # 2D fBm 扩展
│   ├── fbm3d.mbt                  # 3D fBm 扩展
│   ├── image_gen.mbt             # 灰度 / 颜色图输出
│   ├── simplex_noise.mbt         # 公共 API 封装
│   ├── SimplexNoise.mbti         # 导入接口声明
│   └── simplex_noise_tests.mbt   # 单元测试
├── examples/                     # 示例图像输出
├── README.md
├── README_zh_CN.md
└── LICENSE
```

---

## 🔮 未来计划

* 可重复噪声
* 基于分析导数生成 normal map

---

## 📌 协议

本项目采用 MIT License 协议。详见 [LICENSE](./LICENSE)。
