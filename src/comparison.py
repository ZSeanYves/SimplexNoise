import os
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
from skimage.metrics import structural_similarity as ssim
from noise import snoise2, snoise3, snoise4

def load_image(path, target_shape=None):
    img = Image.open(path).convert('L')
    if target_shape:
        img = img.resize(target_shape[::-1], Image.BILINEAR)  # (h,w) → (w,h) for PIL
    return np.array(img) / 255.0

def compare_images(title, img1, img2):
    if img1.shape != img2.shape:
        raise ValueError(f"Image shape mismatch: {img1.shape} vs {img2.shape}")

    mse = np.mean((img1 - img2) ** 2)
    ssim_score = ssim(img1, img2, data_range=1.0)

    print(f"【{title}】")
    print(f"→ MSE:  {mse:.6f}")
    print(f"→ SSIM: {ssim_score:.6f}")

    # 判断是否符合标准
    if mse < 0.01 and ssim_score > 0.95:
        print(" MoonBit 输出图像符合标准。")
    else:
        print(" MoonBit 输出图像不符合标准，请检查实现或图像维度。")

    # 可视化展示
    fig, axs = plt.subplots(1, 2, figsize=(8, 4))
    axs[0].imshow(img1, cmap='gray')
    axs[0].set_title("Reference")
    axs[1].imshow(img2, cmap='gray')
    axs[1].set_title("MoonBit")
    for ax in axs: ax.axis('off')
    plt.suptitle(title)
    plt.tight_layout()
    plt.show()


def generate_noise2d_basic(size=256, scale=0.05):
    return np.array([[snoise2(x * scale, y * scale) for x in range(size)] for y in range(size)])


def generate_noise2d_fbm(size=256, octaves=5, persistence=0.5, lacunarity=2.0, scale=0.03):
    arr = np.zeros((size, size))
    for i in range(octaves):
        freq = lacunarity ** i
        amp = persistence ** i
        for y in range(size):
            for x in range(size):
                arr[y][x] += snoise2(x * scale * freq, y * scale * freq) * amp
    return arr / np.max(np.abs(arr))


def generate_noise3d_basic(size=256, scale=0.05, z=0.3):
    return np.array([[snoise3(x * scale, y * scale, z) for x in range(size)] for y in range(size)])


def generate_noise3d_fbm(size=256, z=0.3, octaves=5, persistence=0.5, lacunarity=2.0, scale=0.03):
    arr = np.zeros((size, size))
    for i in range(octaves):
        freq = lacunarity ** i
        amp = persistence ** i
        for y in range(size):
            for x in range(size):
                arr[y][x] += snoise3(x * scale * freq, y * scale * freq, z * freq) * amp
    return arr / np.max(np.abs(arr))


def generate_noise4d_basic(size=256, scale=0.05, z=0.3, w=0.6):
    return np.array([[snoise4(x * scale, y * scale, z, w) for x in range(size)] for y in range(size)])


def generate_noise4d_fbm(size=256, z=0.3, w=0.6, octaves=5, persistence=0.5, lacunarity=2.0, scale=0.03):
    arr = np.zeros((size, size))
    for i in range(octaves):
        freq = lacunarity ** i
        amp = persistence ** i
        for y in range(size):
            for x in range(size):
                arr[y][x] += snoise4(x * scale * freq, y * scale * freq, z * freq, w * freq) * amp
    return arr / np.max(np.abs(arr))

def main():
    path_map = {
        "1": "./src/examples/comparison/snoise2d_moonbit.png",
        "2": "./src/examples/comparison/fbm2d_moonbit.png",
        "3": "./src/examples/comparison/snoise3d_moonbit.png",
        "4": "./src/examples/comparison/fbm3d_moonbit.png",
        "5": "./src/examples/comparison/snoise4d_moonbit.png",
        "6": "./src/examples/comparison/fbm4d_moonbit.png",
    }

    print("请输入要比对的类型：")
    print("1 - 2D Basic")
    print("2 - 2D fBm")
    print("3 - 3D Basic")
    print("4 - 3D fBm")
    print("5 - 4D Basic")
    print("6 - 4D fBm")
    print("end - 退出")

    while True:
        choice = input(">>> ").strip().lower()
        size = 128

        if choice == "1":
            ref = generate_noise2d_basic(size)
        elif choice == "2":
            ref = generate_noise2d_fbm(size)
        elif choice == "3":
            ref = generate_noise3d_basic(size, z=0.0)
        elif choice == "4":
            ref = generate_noise3d_fbm(size, z=0.0)
        elif choice == "5":
            ref = generate_noise4d_basic(size, z=0.0, w=0.0)
        elif choice == "6":
            ref = generate_noise4d_fbm(size, z=0.0, w=0.0)
        elif choice == "end":
            print("程序结束。")
            break
        else:
            print("无效选项，请重新输入。")
            continue

        moonbit_path = path_map.get(choice)
        if not os.path.exists(moonbit_path):
            print(f"MoonBit 图像未找到: {moonbit_path}")
            continue

        moonbit = load_image(moonbit_path, target_shape=ref.shape)
        compare_images(f"Noise Comparison - Option {choice}", ref, moonbit)

if __name__ == "__main__":
    main()
