//2D
test "Basic Simplex Noise Image" {
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise(42)
  //父目录写法按系统自行调整，这里及下面默认按windows路径
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_noise_image(
    "./src/examples/gray/basic/noise2d.png", 256, 256, 0.05, 42, grads,
  )
  assert_eq(ok, true)
}


test "fBm Noise Image (Cloud/Heightmap)" {
  let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = create_simplex_noise(123)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_fbm_image(
    "./src/examples/gray/fbm/noise2d.png", 256, 256, 123, grads, config,
  )
  assert_eq(ok, true)
}

test "Basic Simplex Noise Image (Color)" {
  let (_, grads) = create_simplex_noise(42)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_noise_image_color(
    "./src/examples/color/basic/noise2d_color.png", 256, 256, 0.05, 42, grads,
  )
  assert_eq(ok, true)
}

test "fBm Noise Image (Color)" {
  let config = new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = create_simplex_noise(123)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_fbm_image_color(
    "./src/examples/color/fbm/noise2d_color.png", 256, 256, 123, grads, config,
  )
  assert_eq(ok, true)
}


test "Permutation Table Initialization" {
  let (perm, _) = create_simplex_noise(7)
  assert_eq(perm.length(), 512)  
  assert_eq(perm[0] >= 0 && perm[0] < 256,true)
}

test "Gradient Vector Validity" {
  for g in grads {
    let len = (g[0] * g[0] + g[1] * g[1]).sqrt()
    assert_eq(len >= 0.9 && len <= 1.1,true)  // 梯度噪声向量
  }
}

test "2D Simplex Noise Output Range" {
  let (perm, _) = create_simplex_noise(99)
  for i in 0..<100 {
    for j in 0..<100 {
      let val = noise2d([i.to_float() * 0.05, j.to_float() * 0.05], perm, grads)
      assert_eq(val >= -1.1 && val <= 1.1,true)  // 理论范围 [-1, 1]，考虑浮点误差
    }
  }
}

test "Single Vertex Contribution Debug" {
  let (perm, _) = create_simplex_noise(1)
  let c = @ZSeanYves/SimplexNoise.simplex2d_debug([0.1, 0.1], perm, grads)

  // 可根据观察值补充 assert
  assert_eq(c[0] >= -1.0 && c[0] <= 1.0,true)
  assert_eq(c[1] >= -1.0 && c[1] <= 1.0,true)
  assert_eq(c[2] >= -1.0 && c[2] <= 1.0,true)
}








// 3D
test "3D Simplex Noise Slice Image" {
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise3d(42)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_noise3d_image(
    "./src/examples/gray/basic/noise3d.png",
    256,
    256,
    0.05,
    0.3,  // z 切片位置
    42,
    grads
  )
  assert_eq(ok, true)
}

test "3D fBm Noise Slice Image" {
  let config = new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = create_simplex_noise3d(123)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_fbm3d_image(
    "./src/examples/gray/fbm/noise3d.png",
    256,
    256,
    0.3,  // z 切片位置
    123,
    grads,
    config
  )
  assert_eq(ok, true)
}

test "3D Simplex Noise Slice Image (Color)" {
  let (_, grads) = create_simplex_noise3d(42)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_noise3d_image_color(
    "./src/examples/color/basic/noise3d_color.png",
    256,
    256,
    0.05,
    0.3,
    42,
    grads
  )
  assert_eq(ok, true)
}

test "3D fBm Noise Slice Image (Color)" {
  let config = new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = create_simplex_noise3d(123)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_fbm3d_image_color(
    "./src/examples/color/fbm/noise3d_color.png",
    256,
    256,
    0.3,
    123,
    grads,
    config
  )
  assert_eq(ok, true)
}


test "3D Simplex Noise Slices Batch Output" {
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise3d(42)
  @ZSeanYves/SimplexNoise.generate_3d_slices(
    "./src/examples/slice_3d/gray/basic",
    128,
    128,
    0.05,
    42,
    grads,
    10 // 切片数量
  )
}

test "3D fBm Noise Slices Batch Output" {
  let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(4, 0.5, 2.0, 0.03)
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise3d(123)
  @ZSeanYves/SimplexNoise.generate_fbm3d_slices(
    "./src/examples/slice_3d/gray/fbm",
    128,
    128,
    123,
    grads,
    config,
    10
  )
}


test "3D Simplex Noise Slices Batch Output (Color)" {
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise3d(42)
  @ZSeanYves/SimplexNoise.generate_3d_slices_color(
    "./src/examples/slice_3d/color/basic",
    128,
    128,
    0.05,
    42,
    grads,
    10
  )
}


test "3D fBm Noise Slices Batch Output (Color)" {
  let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(4, 0.5, 2.0, 0.03)
  let (_, grads3d) = @ZSeanYves/SimplexNoise.create_simplex_noise3d(123)
  @ZSeanYves/SimplexNoise.generate_fbm3d_slices_color(
    "./src/examples/slice_3d/color/fbm",
    128,
    128,
    123,
    grads3d,
    config,
    10
  )
}

test "Simplex Noise 3D - Output Range & Smoothness" {
  let (perm, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise3d(42)

 let mut min_val = 1_000_000_000.0
  let mut max_val = -1_000_000_000.0
  let mut last = 0.0
  let mut diff_sum = 0.0
  let mut count = 0

  for x in 0..<10 {
    for y in 0..<10 {
      for z in 0..<10 {
        let px = x.to_float() * 0.1
        let py = y.to_float() * 0.1
        let pz = z.to_float() * 0.1
        let val = @ZSeanYves/SimplexNoise.noise3d([px, py, pz], perm, grads)  
        if val < min_val.to_float() { min_val = val.to_double() }
        if val > max_val.to_float() { max_val = val.to_double() }
        diff_sum += (val.to_double() - last).abs()
        last = val.to_double()
        count += 1
      }
    }
  }

  assert_eq(min_val >= -1.2 && max_val <= 1.2,true)  // 合理范围
  assert_eq(diff_sum / count.to_double() < 0.5,true) // 平滑性
}

test "fBm Noise 3D - Output Range & Smoothness" {
  let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(4, 0.5, 2.0, 0.03)
  let (perm, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise3d(42)

  let mut min_val = 1_000_000_000.0
  let mut max_val = -1_000_000_000.0
  let mut last = 0.0
  let mut diff_sum = 0.0
  let mut count = 0

  for x in 0..<10 {
    for y in 0..<10 {
      for z in 0..<10 {
        let px = x.to_float() * 0.1
        let py = y.to_float() * 0.1
        let pz = z.to_float() * 0.1
        let val = @ZSeanYves/SimplexNoise.fbm3d([px, py, pz], config.octaves, config.persistence, config.lacunarity, perm, grads)
        if val < min_val.to_float() { min_val = val.to_double() }
        if val > max_val.to_float() { max_val = val.to_double() }
        diff_sum += (val.to_double() - last).abs()
        last = val.to_double()
        count += 1
      }
    }
  }

  assert_eq(min_val >= -1.2 && max_val <= 1.2, true)
  assert_eq(diff_sum / count.to_double() < 0.5, true)
}









// 4D
test "4D Simplex Noise Slice Image" {
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise4d(42)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_noise4d_image(
    "./src/examples/gray/basic/noise4d.png",
    256,
    256,
    0.05,
    0.3,  // z
    0.6,  // w
    42,
    grads
  )
  assert_eq(ok, true)
}


test "4D fBm Noise Slice Image" {
  let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise4d(123)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_fbm4d_image(
    "./src/examples/gray/fbm/noise4d.png",
    256,
    256,
    0.3,
    0.6,
    123,
    grads,
    config
  )
  assert_eq(ok, true)
}

test "4D Simplex Noise Slice Image (Color)" {
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise4d(42)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_noise4d_image_color(
    "./src/examples/color/basic/noise4d_color.png",
    256,
    256,
    0.05,
    0.3,
    0.6,
    42,
    grads
  )
  assert_eq(ok, true)
}


test "4D fBm Noise Slice Image (Color)" {
  let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise4d(123)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_fbm4d_image_color(
    "./src/examples/color/fbm/noise4d_color.png",
    256,
    256,
    0.3,
    0.6,
    123,
    grads,
    config
  )
  assert_eq(ok, true)
}


test "4D Simplex Noise Slices Batch Output" {
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise4d(42)
  @ZSeanYves/SimplexNoise.generate_4d_slices(
    "./src/examples/slice_4d/gray/basic",
    128,
    128,
    0.05,
    0.6,  // 固定 w，切 z 轴
    42,
    grads,
    10
  )
}


test "4D fBm Noise Slices Batch Output" {
  let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(4, 0.5, 2.0, 0.03)
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise4d(123)
  @ZSeanYves/SimplexNoise.generate_fbm4d_slices(
    "./src/examples/slice_4d/gray/fbm",
    128,
    128,
    0.6,  // 固定 w
    123,
    grads,
    config,
    10
  )
}


test "4D Simplex Noise Slices Batch Output (Color)" {
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise4d(42)
  @ZSeanYves/SimplexNoise.generate_4d_slices_color(
    "./src/examples/slice_4d/color/basic",
    128,
    128,
    0.05,
    0.6,  // 固定 w
    42,
    grads,
    10
  )
}


test "4D fBm Noise Slices Batch Output (Color)" {
  let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(4, 0.5, 2.0, 0.03)
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise4d(123)
  @ZSeanYves/SimplexNoise.generate_fbm4d_slices_color(
    "./src/examples/slice_4d/color/fbm",
    128,
    128,
    0.6,  // 固定 w
    123,
    grads,
    config,
    10
  )
}

test "Simplex Noise 4D - Output Range & Smoothness" {
  let (perm, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise4d(123)

  let mut min_val = 1_000_000_000.0
  let mut max_val = -1_000_000_000.0
  let mut last = 0.0
  let mut diff_sum = 0.0
  let mut count = 0

  for x in 0..<6 {
    for y in 0..<6 {
      for z in 0..<6 {
        for w in 0..<6 {
          let px = x.to_float() * 0.2
          let py = y.to_float() * 0.2
          let pz = z.to_float() * 0.2
          let pw = w.to_float() * 0.2
          let val = @ZSeanYves/SimplexNoise.noise4d([px, py, pz, pw], perm, grads)
          if val < min_val.to_float() { min_val = val.to_double() }
          if val > max_val.to_float() { max_val = val.to_double() }
          diff_sum += (val.to_double() - last).abs()
          last = val.to_double()
          count += 1
        }
      }
    }
  }

  assert_eq(min_val >= -1.2 && max_val <= 1.2, true)
  assert_eq(diff_sum / count.to_double() < 0.5, true)
}




test "fBm Noise 4D - Output Range & Smoothness" {
  let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(4, 0.5, 2.0, 0.03)
  let (perm, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise4d(456)

  let mut min_val = 1_000_000_000.0
  let mut max_val = -1_000_000_000.0
  let mut last = 0.0
  let mut diff_sum = 0.0
  let mut count = 0

  for x in 0..<6 {
    for y in 0..<6 {
      for z in 0..<6 {
        for w in 0..<6 {
          let px = x.to_float() * 0.2
          let py = y.to_float() * 0.2
          let pz = z.to_float() * 0.2
          let pw = w.to_float() * 0.2
          let val = @ZSeanYves/SimplexNoise.fbm4d([px, py, pz, pw], config.octaves, config.persistence, config.lacunarity, perm, grads)
          if val < min_val.to_float() { min_val = val.to_double() }
          if val > max_val.to_float() { max_val = val.to_double() }
          diff_sum += (val.to_double() - last).abs()
          last = val.to_double()
          count += 1
        }
      }
    }
  }

  assert_eq(min_val >= -1.2 && max_val <= 1.2, true)
  assert_eq(diff_sum / count.to_double() < 0.5, true)
}

