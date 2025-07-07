# 🎨 SimplexNoise：基于 MoonBit 的 2D / 3D Simplex 噪声与 fBm 噪声库

[English](https://github.com/ZSeanYves/SimplexNoise/blob/main/README.md) | [简体中文](https://github.com/ZSeanYves/SimplexNoise/blob/main/README_zh_CN.md)

[![构建状态](https://img.shields.io/github/actions/workflow/status/ZSeanYves/SimplexNoise/simplex_noise_ci.yml)](https://github.com/ZSeanYves/SimplexNoise/actions)
[![许可证](https://img.shields.io/github/license/ZSeanYves/SimplexNoise)](LICENSE)

**SimplexNoise** 是一个轻量级 MoonBit 噪声库，支持 2D 和 3D Simplex 噪声、多八度分形布朗运动 (fBm) 噪声、灰度和彩色图像输出。适用于地形生成、云图、程序纹理、体噪声切片可视化与教学用途。

---

## 🚀 主要功能

* **2D 与 3D Simplex 噪声**，支持种子控制
* **多八度 fBm 噪声**，可配置八度数、持久度、间隙度
* **灰度与彩色 PNG 图像输出**
* **3D 单切片与多切片批量输出**
* **自定义颜色映射方案**
* **结构清晰、易拓展的 MoonBit 设计**

---

## 📦 安装方式

```bash
moon add ZSeanYves/SimplexNoise
```

或手动编辑 `moon.mod.json`：

```json
"import": ["ZSeanYves/SimplexNoise"]
```

---

## 🎨 基础示例

### 2D 灰度噪声图像

```moonbit
let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise(42)
@ZSeanYves/SimplexNoise.generate_and_save_noise_image("./noise.png", 256, 256, 0.05, 42, grads)
//返回Bool，其他的也是
```

### 2D 彩色 fBm 噪声图像

```moonbit
let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(5, 0.5, 2.0, 0.03)
let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise(123)
@ZSeanYves/SimplexNoise.generate_and_save_fbm_image_color("./fbm_color.png", 256, 256, 123, grads, config)
```

### 3D 单切片噪声图像

```moonbit
let (_, grads3d) = @ZSeanYves/SimplexNoise.create_simplex_noise3d(42)
@ZSeanYves/SimplexNoise.generate_and_save_noise3d_image("./slice.png", 256, 256, 0.05, 0.3, 42, grads3d)
```

### 3D 多切片批量输出

```moonbit
@ZSeanYves/SimplexNoise.generate_3d_slices("./slices", 128, 128, 0.05, 42, grads3d, 20)
```

---

## 📘 API 速览

### 2D 图像输出

| 函数                                    | 说明                   |
| ------------------------------------- | -------------------- |
| `generate_and_save_noise_image`       | 生成 2D 灰度 Simplex 噪声图 |
| `generate_and_save_fbm_image`         | 生成 2D 灰度 fBm 噪声图     |
| `generate_and_save_noise_image_color` | 生成 2D 彩色 Simplex 噪声图 |
| `generate_and_save_fbm_image_color`   | 生成 2D 彩色 fBm 噪声图     |

### 3D 切片输出

| 函数                                      | 说明                |
| --------------------------------------- | ----------------- |
| `generate_and_save_noise3d_image`       | 生成 3D 单切片灰度图      |
| `generate_and_save_fbm3d_image`         | 生成 3D fBm 单切片灰度图  |
| `generate_and_save_noise3d_image_color` | 生成 3D 单切片彩色图      |
| `generate_and_save_fbm3d_image_color`   | 生成 3D fBm 单切片彩色图  |
| `generate_3d_slices`                    | 批量输出 3D 灰度切片图     |
| `generate_fbm3d_slices`                 | 批量输出 3D fBm 灰度切片图 |
| `generate_3d_slices_color`              | 批量输出 3D 彩色切片图     |
| `generate_fbm3d_slices_color`           | 批量输出 3D fBm 彩色切片图 |

---

## 🎛️ 可配置选项

| 配置项                  | 说明                 | 对应函数                                                                       |
| -------------------- | ------------------ | -------------------------------------------------------------------------- |
| **种子 Seed**          | 控制置换表的随机性          | `create_simplex_noise(seed)` (2D) <br> `create_simplex_noise3d(seed)` (3D) |
| **NoiseConfig 配置结构** | 配置八度数、持久度、间隙度、缩放系数 | `new_NoiseConfig(octaves, persistence, lacunarity, scale)`                 |
| **颜色映射**             | 自定义渐变色方案           | 修改 `noise_to_color(val: Float) -> @color.RGBA`                             |

---

## 📂 项目结构

```
SimplexNoise/
├── src/
│   ├── fbm.mbt                     # 2D fBm 噪声逻辑
│   ├── fbm3d.mbt                   # 3D fBm 噪声逻辑
│   ├── image_gen.mbt               # 图像输出（2D & 3D）
│   ├── noise2d.mbt                 # 2D Simplex 噪声
│   ├── noise3d.mbt                 # 3D Simplex 噪声
│   ├── random.mbt                  # 基于种子的置换表
│   ├── simplex_noise.mbt           # 公开 API 封装
│   ├── simplex_noise_tests.mbt     # 单元测试
│   ├── SimplexNoise.mbti           # 公共接口与配置结构
│   └── moon.pkg.json               # 项目元数据
├── examples/                       # 示例输出图像
├── LICENSE
└── README.md
```

---

## 🧪 测试

运行完整测试套件：

```bash
moon test -p ZSeanYves/simplexnoise
```

---

## ⚡ 未来计划

* 支持 4D 噪声
* 无缝平铺噪声、域扭曲扩展
* 解析导数（法线贴图支持）
* 3D 多切片序列 GIF / 动画工具

---

## 📜 许可证

MIT 许可证，详情见 [LICENSE](./LICENSE)。

---
