// 内部封装：使用 png Encoder 保存图像
fn save_as_png(img: &@image.Image, path: String) {
  let file = @io.file_writer(path).expect("Failed to open file")
  let mut enc = @png.Encoder::new(file, img)
  enc.encode()
}

// 生成单八度 Simplex Noise 灰度图，保存为 PNG 文件
pub fn generate_simplex_png(width: Int, height: Int, scale: Float, seed: Int, path: String) {
  let img = image_gen::generate_noise_image(width, height, scale, seed)
  save_as_png(&img, path)
}

// 生成多八度 fBm Simplex Noise 灰度图，保存为 PNG 文件
pub fn generate_fbm_png(width: Int, height: Int, scale: Float, seed: Int, octaves: Int, persistence: Float, lacunarity: Float, path: String) {
  let img = fbm_image_gen::generate_fbm_image(width, height, scale, seed, octaves, persistence, lacunarity)
  save_as_png(&img, path)
}