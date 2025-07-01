// 统一配置结构
pub struct NoiseConfig {
  octaves: Int
  persistence: Float
  lacunarity: Float
  scale: Float
}

// 初始化置换表和梯度表,允许自定义种子
pub fn create_simplex_noise(seed: Int) -> (Array[Int], Array[Array[Float]]) {
  let perm_table = init_noise(seed)
  (perm_table, grads)
}

// 生成单点 2D Simplex 噪声
pub fn noise2d(p: Array[Float], perm_table: Array[Int], grads: Array[Array[Float]]) -> Float {
  simplex2d(p, perm_table, grads)
}
// 八度数 fBm 噪声
// pub fn fbm2d(p: Array[Float], octaves: Int, persistence: Float, lacunarity: Float, perm_table: Array[Int], grads: Array[Array[Float]]) -> Float 

// 调试辅助：输出单个顶点贡献过程
pub fn debug_simplex2d_step(p: Array[Float], perm_table: Array[Int], grads: Array[Array[Float]]) -> Unit {
  simplex2d_debug(p, perm_table, grads)
}


// 生成并保存 Simplex 噪声 PNG 图像
pub fn generate_and_save_noise_image(
  path: Bytes,
  width: Int,
  height: Int,
  scale: Float,
  seed: Int,
  grads: Array[Array[Float]]
) -> Bool raise @image.SizeError {
  let png_data = generate_noise_png_buffer(width, height, scale, seed, grads)
  save_png(path, png_data)
}

// 生成并保存 fBm 噪声 PNG 图像，允许自定义八度配置
pub fn generate_and_save_fbm_image(
  path: Bytes,
  width: Int,
  height: Int,
  seed: Int,
  grads: Array[Array[Float]],
  config: NoiseConfig
) -> Bool raise @image.SizeError {
  let png_data = generate_fbm_png_buffer(width, height, config.scale, seed,config.octaves, config.persistence, config.lacunarity, grads)
  save_png(path, png_data)
}


