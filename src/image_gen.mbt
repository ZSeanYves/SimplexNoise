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
fn noise_to_color(val : Float) -> @color.RGBA {
  let r = (val * 255.0).to_int().to_byte()
  let g = ((1.0 - val.to_double()) * 255.0).to_int().to_byte()
  let b = 128
  let a = 255
  @color.RGBA::new(r, g, b.to_byte(), a.to_byte())
}



// 生成指定尺寸的 2D Simplex Noise
fn generate_noise_png_buffer(
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  grads : Array[Array[Float]],
  useWarp : Bool, // 添加 useWarp 参数来控制是否使用 warp2d
  isGrayScale : Bool, // 是否生成灰度图
  strength : Float // 扰动强度
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  if isGrayScale {
    let img = @image.Gray::new(bounds)
    for y in 0..<height {
      for x in 0..<width {
        let val = if useWarp {
          // 使用 warp2d（如果 useWarp 为 true）
          warp2d(grads, [x.to_float(), y.to_float()], seed, scale, strength)
        } else {
          // 使用 simplex2d（如果 useWarp 为 false）
          simplex2d([x.to_float(), y.to_float()], perm_table, grads, scale)
        }
        // 将噪声值映射到灰度范围
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
  } else {
    let img = @image.RGBA::new(bounds)
    for y in 0..<height {
      for x in 0..<width {
        let val = if useWarp {
          warp2d(grads, [x.to_float(), y.to_float()], seed, scale, strength)
        } else {
          simplex2d([x.to_float(), y.to_float()], perm_table, grads, scale)
        }
        let normalized_val = (val + 1.0) * 0.5
        let color = noise_to_color(normalized_val)
        img.set_rgba(x, y, color)
      }
    }
    ignore(@png.encode(buf, img))
  }
  return buf.to_bytes()
}


// 生成 2D fBm 噪声
fn generate_fbm_png_buffer(
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  octaves : Int,
  persistence : Float,
  lacunarity : Float,
  grads : Array[Array[Float]],
  useWarp : Bool, 
  isGrayScale : Bool, 
  strength : Float 
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  if isGrayScale {
    let img = @image.Gray::new(bounds)
    for y in 0..<height {
      for x in 0..<width {
        let val = if useWarp {
          warp_fbm2d(
            grads,
            [x.to_float(), y.to_float()],
            seed,
            scale,
            strength,
            octaves,
            persistence,
            lacunarity,
          )
        } else {
          fbm2d(
            [x.to_float(), y.to_float()],
            octaves,
            persistence,
            lacunarity,
            perm_table,
            grads,
            scale,
          )
        }
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
  } else {
    let img = @image.RGBA::new(bounds)
    for y in 0..<height {
      for x in 0..<width {
        let val = if useWarp {
          warp_fbm2d(
            grads,
            [x.to_float(), y.to_float()],
            seed,
            scale,
            strength,
            octaves,
            persistence,
            lacunarity,
          )
        } else {
          fbm2d(
            [x.to_float(), y.to_float()],
            octaves,
            persistence,
            lacunarity,
            perm_table,
            grads,
            scale,
          )
        }
        let normalized_val = (val + 1.0) * 0.5
        let color = noise_to_color(normalized_val)
        img.set_rgba(x, y, color)
      }
    }
    ignore(@png.encode(buf, img))
  }
  return buf.to_bytes()
}

// 生成指定尺寸的 3D Simplex Noise
fn generate_noise3d_png_buffer(
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]],
  useWarp : Bool, 
  isGrayScale : Bool,
  strength : Float 
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  if isGrayScale {
    let img = @image.Gray::new(bounds)
    for y in 0..<height {
      for x in 0..<width {
        let val = if useWarp {
          warp3d(grads, [x.to_float(), y.to_float(), z], seed, scale, strength)
        } else {
          simplex3d([x.to_float(), y.to_float(), z], perm_table, grads, scale)
        }
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
  } else {
    let img = @image.RGBA::new(bounds)
    for y in 0..<height {
      for x in 0..<width {
        let val = if useWarp {
          warp3d(grads, [x.to_float(), y.to_float(), z], seed, scale, strength)
        } else {
          simplex3d([x.to_float(), y.to_float(), z], perm_table, grads, scale)
        }
        let normalized_val = (val + 1.0) * 0.5
        let color = noise_to_color(normalized_val)
        img.set_rgba(x, y, color)
      }
    }
    ignore(@png.encode(buf, img))
  }
  return buf.to_bytes()
}




// 生成 3D fBm 噪声
fn generate_fbm3d_png_buffer(
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  seed : Int,
  octaves : Int,
  persistence : Float,
  lacunarity : Float,
  grads : Array[Array[Float]],
  useWarp : Bool, 
  isGrayScale : Bool, 
  strength : Float 
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  if isGrayScale {
    let img = @image.Gray::new(bounds)
    for y in 0..<height {
      for x in 0..<width {
        let val = if useWarp {
          warp_fbm3d(
            grads,
            [x.to_float(), y.to_float(), z],
            seed,
            scale,
            strength,
            octaves,
            persistence,
            lacunarity,
          )
        } else {
          fbm3d(
            [x.to_float(), y.to_float(), z],
            octaves,
            persistence,
            lacunarity,
            perm_table,
            grads,
            scale,
          )
        }
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
  } else {
    let img = @image.RGBA::new(bounds)
    for y in 0..<height {
      for x in 0..<width {
        let val = if useWarp {
          warp_fbm3d(
            grads,
            [x.to_float(), y.to_float(), z],
            seed,
            scale,
            strength,
            octaves,
            persistence,
            lacunarity,
          )
        } else {
          fbm3d(
            [x.to_float(), y.to_float(), z],
            octaves,
            persistence,
            lacunarity,
            perm_table,
            grads,
            scale,
          )
        }
        let normalized_val = (val + 1.0) * 0.5
        let color = noise_to_color(normalized_val)
        img.set_rgba(x, y, color)
      }
    }
    ignore(@png.encode(buf, img))
  }
  return buf.to_bytes()
}



// 生成指定尺寸的 4D Simplex 噪声
fn generate_noise4d_png_buffer(
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  w : Float,
  seed : Int,
  grads : Array[Array[Float]],
  useWarp : Bool,
  isGrayScale : Bool, 
  strength : Float 
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  if isGrayScale {
    let img = @image.Gray::new(bounds)
    for y in 0..<height {
      for x in 0..<width {
        let val = if useWarp {
          warp4d(
            grads,
            [x.to_float(), y.to_float(), z, w],
            seed,
            scale,
            strength,
          )
        } else {
          simplex4d(
            [x.to_float(), y.to_float(), z, w],
            perm_table,
            grads,
            scale,
          )
        }
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
  } else {
    let img = @image.RGBA::new(bounds)
    for y in 0..<height {
      for x in 0..<width {
        let val = if useWarp {
          warp4d(
            grads,
            [x.to_float(), y.to_float(), z, w],
            seed,
            scale,
            strength,
          )
        } else {
          simplex4d(
            [x.to_float(), y.to_float(), z, w],
            perm_table,
            grads,
            scale,
          )
        }
        let normalized_val = (val + 1.0) * 0.5
        let color = noise_to_color(normalized_val)
        img.set_rgba(x, y, color)
      }
    }
    ignore(@png.encode(buf, img))
  }
  return buf.to_bytes()
}




// 生成 4D fBm 噪声
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
  grads : Array[Array[Float]],
  useWarp : Bool, 
  isGrayScale : Bool, 
  strength : Float 
) -> Bytes raise @image.SizeError {
  let buf = @io.Buffer::new(size_hint=1024)
  let perm_table = init_noise(seed)
  let bounds = @image.rect(0, 0, width, height)
  if isGrayScale {
    let img = @image.Gray::new(bounds)
    for y in 0..<height {
      for x in 0..<width {
        let val = if useWarp {
          warp_fbm4d(
            grads,
            [x.to_float(), y.to_float(), z, w],
            seed,
            scale,
            strength,
            octaves,
            persistence,
            lacunarity,
          )
        } else {
          fbm4d(
            [x.to_float(), y.to_float(), z, w],
            octaves,
            persistence,
            lacunarity,
            perm_table,
            grads,
            scale,
          )
        }
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
  } else {
    let img = @image.RGBA::new(bounds)
    for y in 0..<height {
      for x in 0..<width {
        let val = if useWarp {
          warp_fbm4d(
            grads,
            [x.to_float(), y.to_float(), z, w],
            seed,
            scale,
            strength,
            octaves,
            persistence,
            lacunarity,
          )
        } else {
          fbm4d(
            [x.to_float(), y.to_float(), z, w],
            octaves,
            persistence,
            lacunarity,
            perm_table,
            grads,
            scale,
          )
        }
        let normalized_val = (val + 1.0) * 0.5
        let color = noise_to_color(normalized_val)
        img.set_rgba(x, y, color)
      }
    }
    ignore(@png.encode(buf, img))
  }
  return buf.to_bytes()
}
