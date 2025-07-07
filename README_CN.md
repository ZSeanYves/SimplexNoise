# 🎨 SimplexNoise: 基于 MoonBit 的 2D Simplex 噪声与 fBm 噪声库

[English](https://github.com/ZSeanYves/SimplexNoise/blob/main/README.md) | [简体中文](https://github.com/ZSeanYves/SimplexNoise/blob/main/README_zh_CN.md)

[![构建状态](https://img.shields.io/github/actions/workflow/status/ZSeanYves/SimplexNoise/simplex_noise_ci.yml)](https://github.com/ZSeanYves/SimplexNoise/actions)
[![许可证](https://img.shields.io/github/license/ZSeanYves/SimplexNoise)](LICENSE)

**SimplexNoise** 是一个轻量级的 MoonBit 噪声库，支持 2D Simplex 噪声、多八度分形布朗运动 (fBm) 噪声，以及灰度和彩色图像输出。适用于地形生成、云图、程序纹理与教学示例。

---

## 🚀 主要功能

* **2D Simplex 噪声**，支持种子配置
* **多八度 fBm 噪声**（可配置八度数、持久度、间隙度）
* **灰度与彩色 PNG 图像输出**
* **可自定义颜色映射方案**
* **模块清晰、易扩展的 MoonBit 设计**

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

## 🎨 基础用法

### 生成灰度噪声图像

```moonbit
let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise(42)
@ZSeanYves/SimplexNoise.generate_and_save_noise_image("./noise.png", 256, 256, 0.05, 42, grads)
// 返回 Bool 类型，表示保存成功与否
```

### 生成彩色 fBm 噪声图像

```moonbit
let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(5, 0.5, 2.0, 0.03)
let (_, grads) = create_simplex_noise(123)
@ZSeanYves/SimplexNoise.generate_and_save_fbm_image_color("./fbm_color.png", 256, 256, 123, grads, config)
```

---

## 📘 API 速览

### Simplex 噪声图像

| 函数                                    | 说明               |
| ------------------------------------- | ---------------- |
| `generate_and_save_noise_image`       | 生成灰度 Simplex 噪声图 |
| `generate_and_save_noise_image_color` | 生成彩色 Simplex 噪声图 |

### fBm 多八度噪声图像

| 函数                                  | 说明           |
| ----------------------------------- | ------------ |
| `generate_and_save_fbm_image`       | 生成灰度 fBm 噪声图 |
| `generate_and_save_fbm_image_color` | 生成彩色 fBm 噪声图 |

---

## 🎛️ 可配置选项

* **Seed（种子）**：控制置换表随机性
* **NoiseConfig 配置结构**：八度数、持久度、间隙度、缩放系数
* **颜色映射**：可修改 `noise_to_color` 自定义渐变色方案

---

## 📂 项目结构

```
SimplexNoise/
├── src/
│   ├── fbm.mbt                   # fBm 噪声核心逻辑
│   ├── image_gen.mbt             # 图像输出（灰度与彩色）
│   ├── noise2d.mbt               # 2D Simplex 噪声核心
│   ├── random.mbt                # 基于种子的置换表
│   ├── simplex_noise.mbt         # 公开 API 封装
│   ├── simplex_noise_tests.mbt   # 单元测试
│   ├── SimplexNoise.mbti         # 公共接口与配置结构
│   └── moon.pkg.json             # 项目元数据
├── examples/                     # 示例输出图像
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

## ⚡ 后续更新

* 支持 3D / 4D 噪声
* 无缝平铺噪声、域扭曲扩展
* 解析导数（法线贴图支持）

---

## 📜 许可证

MIT 许可证，详情见 [LICENSE](./LICENSE)。

---
