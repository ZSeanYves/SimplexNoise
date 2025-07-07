fn save_png(path : String, png_data : Bytes) -> Bool raise @fs.IOError {
  match (try? @fs.write_bytes_to_file(path, png_data)) {
    Ok(_) => true
    Err(e) => {
      raise e
      false
    }
  }
}

// 渐变色映射工具
fn noise_to_color(val: Float) -> @color.RGBA {
  let r = (val * 255.0).to_int().to_byte()
  let g = ((1.0 - val.to_double()) * 255.0).to_int().to_byte()
  let b = 128
  let a = 255
  @color.RGBA::new(r, g, b.to_byte(), a.to_byte())
}


// 生成指定尺寸的 2D Simplex Noise，输出 PNG 二进制数据
fn generate_noise_png_buffer(
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  grads : Array[Array[Float]]
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.Gray::new(bounds)
  for y in 0..<height {
    for x in 0..<width {
      let nx = x.to_float() * scale
      let ny = y.to_float() * scale
      let val = simplex2d([nx, ny], perm_table, grads)
      let raw_val = (val + 1.0) * 0.5 * 255.0
      let gray_val = if raw_val < 0.0 {
        0
      } else if raw_val > 255.0 {
        255
      } else {
        raw_val.to_int()
      }
      img.set_gray(x, y, @color.Gray::new(gray_val.to_byte()))
    }
  }
  ignore(@png.encode(buf, img))
  buf.to_bytes()
}



// 生成 2D fBm 噪声，输出 PNG 二进制数据
fn generate_fbm_png_buffer(
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  octaves : Int,
  persistence : Float,
  lacunarity : Float,
  grads : Array[Array[Float]]
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.Gray::new(bounds)
  for y in 0..<height {
    for x in 0..<width {
      let nx = x.to_float() * scale
      let ny = y.to_float() * scale
      let val = fbm2d(
        [nx, ny],
        octaves,
        persistence,
        lacunarity,
        perm_table,
        grads,
      )
      let raw_val = (val + 1.0) * 0.5 * 255.0
      let gray_val = if raw_val < 0.0 {
        0
      } else if raw_val > 255.0 {
        255
      } else {
        raw_val.to_int()
      }
      img.set_gray(x, y, @color.Gray::new(gray_val.to_byte()))
    }
  }
  ignore(@png.encode(buf, img))
  buf.to_bytes()
}




// 生成指定尺寸的 2D Simplex Noise，输出 PNG 二进制数据，带颜色映射
fn generate_noise_png_buffer_color(
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  grads : Array[Array[Float]]
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.RGBA::new(bounds)

  for y in 0..<height {
    for x in 0..<width {
      let nx = x.to_float() * scale
      let ny = y.to_float() * scale
      let val = simplex2d([nx, ny], perm_table, grads)

      // 映射到 0~1
      let normalized_val = (val + 1.0) * 0.5

      // 自定义颜色映射
      let color = noise_to_color(normalized_val)

      img.set_rgba(x, y, color)
    }
  }
  ignore(@png.encode(buf, img))
  buf.to_bytes()
}

// 生成 2D fBm 噪声，输出 PNG 二进制数据，带颜色映射
fn generate_fbm_png_buffer_color(
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  octaves : Int,
  persistence : Float,
  lacunarity : Float,
  grads : Array[Array[Float]]
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.RGBA::new(bounds)

  for y in 0..<height {
    for x in 0..<width {
      let nx = x.to_float() * scale
      let ny = y.to_float() * scale
      let val = fbm2d(
        [nx, ny],
        octaves,
        persistence,
        lacunarity,
        perm_table,
        grads,
      )

      // 映射到 0~1
      let normalized_val = (val + 1.0) * 0.5

      // 颜色映射
      let color = noise_to_color(normalized_val)

      img.set_rgba(x, y, color)
    }
  }
  ignore(@png.encode(buf, img))
  buf.to_bytes()
}

// 生成指定尺寸的 3D Simplex Noise，输出 PNG 二进制数据
fn generate_noise3d_png_buffer(
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]]
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.Gray::new(bounds)

  for y in 0..<height {
    for x in 0..<width {
      let nx = x.to_float() * scale
      let ny = y.to_float() * scale
      let val = simplex3d([nx, ny, z], perm_table, grads)
      let raw_val = (val + 1.0) * 0.5 * 255.0
      let gray_val = if raw_val < 0.0 {
        0
      } else if raw_val > 255.0 {
        255
      } else {
        raw_val.to_int()
      }
      img.set_gray(x, y, @color.Gray::new(gray_val.to_byte()))
    }
  }
  ignore(@png.encode(buf, img))
  buf.to_bytes()
}

// 生成 3D fBm 噪声，输出 PNG 二进制数据
fn generate_fbm3d_png_buffer(
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  seed : Int,
  octaves : Int,
  persistence : Float,
  lacunarity : Float,
  grads : Array[Array[Float]]
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.Gray::new(bounds)

  for y in 0..<height {
    for x in 0..<width {
      let nx = x.to_float() * scale
      let ny = y.to_float() * scale
      let val = fbm3d([nx, ny, z], octaves, persistence, lacunarity, perm_table, grads)
      let raw_val = (val + 1.0) * 0.5 * 255.0
      let gray_val = if raw_val < 0.0 {
        0
      } else if raw_val > 255.0 {
        255
      } else {
        raw_val.to_int()
      }
      img.set_gray(x, y, @color.Gray::new(gray_val.to_byte()))
    }
  }
  ignore(@png.encode(buf, img))
  buf.to_bytes()
}

// 生成指定尺寸的 3D Simplex Noise，输出 PNG 二进制数据，带颜色映射
fn generate_noise3d_png_buffer_color(
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]]
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.RGBA::new(bounds)

  for y in 0..<height {
    for x in 0..<width {
      let nx = x.to_float() * scale
      let ny = y.to_float() * scale
      let val = simplex3d([nx, ny, z], perm_table, grads)
      let normalized_val = (val + 1.0) * 0.5
      let color = noise_to_color(normalized_val)
      img.set_rgba(x, y, color)
    }
  }
  ignore(@png.encode(buf, img))
  buf.to_bytes()
}

// 生成 3D fBm 噪声，输出 PNG 二进制数据，带颜色映射
fn generate_fbm3d_png_buffer_color(
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  seed : Int,
  octaves : Int,
  persistence : Float,
  lacunarity : Float,
  grads : Array[Array[Float]]
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.RGBA::new(bounds)

  for y in 0..<height {
    for x in 0..<width {
      let nx = x.to_float() * scale
      let ny = y.to_float() * scale
      let val = fbm3d([nx, ny, z], octaves, persistence, lacunarity, perm_table, grads)
      let normalized_val = (val + 1.0) * 0.5
      let color = noise_to_color(normalized_val)
      img.set_rgba(x, y, color)
    }
  }
  ignore(@png.encode(buf, img))
  buf.to_bytes()
}

// 生成 4D Simplex 噪声图像（灰度）
fn generate_noise4d_png_buffer(
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  w : Float,
  seed : Int,
  grads : Array[Array[Float]]
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.Gray::new(bounds)

  for y in 0..<height {
    for x in 0..<width {
      let nx = x.to_float() * scale
      let ny = y.to_float() * scale
      let val = simplex4d([nx, ny, z, w], perm_table, grads)
      let raw_val = (val + 1.0) * 0.5 * 255.0
      let gray_val = if raw_val < 0.0 {
        0
      } else if raw_val > 255.0 {
        255
      } else {
        raw_val.to_int()
      }
      img.set_gray(x, y, @color.Gray::new(gray_val.to_byte()))
    }
  }
  ignore(@png.encode(buf, img))
  buf.to_bytes()
}

// 生成 4D fBm 噪声图像（灰度）
fn generate_fbm4d_png_buffer(
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  w : Float,
  seed : Int,
  octaves : Int,
  persistence : Float,
  lacunarity : Float,
  grads : Array[Array[Float]]
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.Gray::new(bounds)

  for y in 0..<height {
    for x in 0..<width {
      let nx = x.to_float() * scale
      let ny = y.to_float() * scale
      let val = fbm4d([nx, ny, z, w], octaves, persistence, lacunarity, perm_table, grads)
      let raw_val = (val + 1.0) * 0.5 * 255.0
      let gray_val = if raw_val < 0.0 {
        0
      } else if raw_val > 255.0 {
        255
      } else {
        raw_val.to_int()
      }
      img.set_gray(x, y, @color.Gray::new(gray_val.to_byte()))
    }
  }
  ignore(@png.encode(buf, img))
  buf.to_bytes()
}

// 生成 4D Simplex 噪声图像（彩色）
fn generate_noise4d_png_buffer_color(
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  w : Float,
  seed : Int,
  grads : Array[Array[Float]]
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.RGBA::new(bounds)

  for y in 0..<height {
    for x in 0..<width {
      let nx = x.to_float() * scale
      let ny = y.to_float() * scale
      let val = simplex4d([nx, ny, z, w], perm_table, grads)
      let normalized_val = (val + 1.0) * 0.5
      let color = noise_to_color(normalized_val)
      img.set_rgba(x, y, color)
    }
  }
  ignore(@png.encode(buf, img))
  buf.to_bytes()
}

// 生成 4D fBm 噪声图像（彩色）
fn generate_fbm4d_png_buffer_color(
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  w : Float,
  seed : Int,
  octaves : Int,
  persistence : Float,
  lacunarity : Float,
  grads : Array[Array[Float]]
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  let img = @image.RGBA::new(bounds)

  for y in 0..<height {
    for x in 0..<width {
      let nx = x.to_float() * scale
      let ny = y.to_float() * scale
      let val = fbm4d([nx, ny, z, w], octaves, persistence, lacunarity, perm_table, grads)
      let normalized_val = (val + 1.0) * 0.5
      let color = noise_to_color(normalized_val)
      img.set_rgba(x, y, color)
    }
  }
  ignore(@png.encode(buf, img))
  buf.to_bytes()
}
