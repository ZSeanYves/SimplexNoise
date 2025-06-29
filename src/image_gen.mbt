// 生成指定尺寸的 2D Simplex Noise 灰度图，输出为 Gray 图像
pub fn generate_noise_image(width: Int, height: Int, scale: Float, seed: Int) -> @image.Gray {
  noise2d::init_permutation(seed)

  let bounds = @image.rect::rect(0, 0, width, height)
  let img = @image.Gray::new(bounds)

  for y in 0..height {
    for x in 0..width {
      let nx = (x as Float) * scale
      let ny = (y as Float) * scale
      let val = noise2d::simplex2d(@la.Vector::from_array([nx, ny]))

      // 映射到 0~255 灰度值
      let gray = ((val + 1.0) * 0.5 * 255.0).clamp(0.0, 255.0) as Int

      img.set_gray(x, y, @image.color::Gray(gray as Byte))
    }
  }

  img
}


// 生成 2D fBm 噪声图像，输出 Gray 图像
pub fn generate_fbm_image(width: Int, height: Int, scale: Float, seed: Int, octaves: Int, persistence: Float, lacunarity: Float) -> @image.Gray {
  noise2d::init_permutation(seed)

  let bounds = @image.rect::rect(0, 0, width, height)
  let img = @image.Gray::new(bounds)

  for y in 0..height {
    for x in 0..width {
      let nx = (x as Float) * scale
      let ny = (y as Float) * scale
      let val = fbm::fbm2d(@la.Vector::from_array([nx, ny]), octaves, persistence, lacunarity)

      // 映射到 0~255 灰度值
      let gray = ((val + 1.0) * 0.5 * 255.0).clamp(0.0, 255.0) as Int

      img.set_gray(x, y, @image.color::Gray(gray as Byte))
    }
  }

  img
}

