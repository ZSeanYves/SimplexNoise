// 生成指定尺寸的 2D Simplex Noise，输出 PNG 二进制数据
fn generate_noise_png_buffer(width: Int, height: Int, scale: Float, seed: Int, grads: Array[Array[Float]]) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.Gray::new(bounds)

  for y in 0..<height {
    for x in 0..<width {
      let nx = (x.to_float()) * scale
      let ny = (y.to_float()) * scale
      let val = simplex2d([nx, ny], perm_table, grads)

      let raw_val = ((val + 1.0) * 0.5 * 255.0)
      let gray_val = if raw_val < 0.0 { 0 } else if raw_val > 255.0 { 255 } else { raw_val.to_int() }
      img.set_gray(x, y, @color.Gray::new(gray_val.to_byte()))
    }
  }

  ignore(@png.encode(buf, img))
  buf.to_bytes()
}

// 生成 2D fBm 噪声，输出 PNG 二进制数据
fn generate_fbm_png_buffer(width: Int, height: Int, scale: Float, seed: Int, octaves: Int, persistence: Float, lacunarity: Float, grads: Array[Array[Float]]) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.Gray::new(bounds)

  for y in 0..<height {
    for x in 0..<width {
      let nx = (x.to_float()) * scale
      let ny = (y.to_float()) * scale
      let val = fbm2d([nx, ny], octaves, persistence, lacunarity, perm_table, grads)

      let raw_val = ((val + 1.0) * 0.5 * 255.0)
      let gray_val = if raw_val < 0.0 { 0 } else if raw_val > 255.0 { 255 } else { raw_val.to_int() }
      img.set_gray(x, y, @color.Gray::new(gray_val.to_byte()))
    }
  }

  ignore(@png.encode(buf, img))
  buf.to_bytes()
}

