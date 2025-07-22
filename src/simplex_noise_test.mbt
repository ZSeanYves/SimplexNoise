//2D
test "Basic Simplex Noise Image" {
  let (_, grads) = @ZSeanYves/SimplexNoise.create2d(42)
  //父目录写法按系统自行调整，这里及下面默认按windows路径
  let ok = @ZSeanYves/SimplexNoise.noise2d_image(
    "./src/examples/gray/basic/noise2d.png", 256, 256, 0.05, 42, grads, false, true,
    1.0,
  )
  //这个strength = 1.0 取值无所谓，因为已经提前确认不使用wrap
  assert_eq(ok, true)
}


test "fBm Noise Image (Cloud/Heightmap)" {
  let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = create2d(123)
  let ok = @ZSeanYves/SimplexNoise.fbm2d_image(
    "./src/examples/gray/fbm/noise2d.png", 256, 256, 123, grads, config, false, true,
    1.0,
  )
  assert_eq(ok, true)
}

test "Basic Simplex Noise Image (Color)" {
  let (_, grads) = create2d(42)
  let ok = @ZSeanYves/SimplexNoise.noise2d_image(
    "./src/examples/color/basic/noise2d_color.png", 256, 256, 0.05, 42, grads, false,
    false, 1.0,
  )
  assert_eq(ok, true)
}

test "fBm Noise Image (Color)" {
  let config = new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = create2d(123)
  let ok = @ZSeanYves/SimplexNoise.fbm2d_image(
    "./src/examples/color/fbm/noise2d_color.png", 256, 256, 123, grads, config, false,
    false, 1.0,
  )
  assert_eq(ok, true)
}


test "Permutation Table Initialization" {
  let (perm, _) = create2d(7)
  assert_eq(perm.length(), 512)
  assert_eq(perm[0] >= 0 && perm[0] < 256, true)
}

test "Gradient Vector Validity" {
  for g in grads2d {
    let len = (g[0] * g[0] + g[1] * g[1]).sqrt()
    assert_eq(len >= 0.9 && len <= 1.1, true) // 梯度噪声向量
  }
}

test "2D Simplex Noise Output Range" {
  let (perm, grads) = create2d(99)
  for i in 0..<100 {
    for j in 0..<100 {
      let val = noise2d([i.to_float(), j.to_float()], perm, grads, 0.05)
      assert_eq(val >= -1.1 && val <= 1.1, true) // 理论范围 [-1, 1]，考虑浮点误差
    }
  }
}
//
//
//
//
//
//
//
//
// 3D
test "3D Simplex Noise Slice Image" {
  let (_, grads) = @ZSeanYves/SimplexNoise.create3d(42)
  let ok = @ZSeanYves/SimplexNoise.noise3d_image(
    "./src/examples/gray/basic/noise3d.png", 256, 256, 0.05, 0.3, // z 切片位置
     42, grads, false, true, 1.0,
  )
  assert_eq(ok, true)
}

test "3D fBm Noise Slice Image" {
  let config = new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = create3d(123)
  let ok = @ZSeanYves/SimplexNoise.fbm3d_image(
    "./src/examples/gray/fbm/noise3d.png", 256, 256, 0.3, 123, grads, config, false,
    true, 1.0,
  )
  assert_eq(ok, true)
}

test "3D Simplex Noise Slice Image (Color)" {
  let (_, grads) = create3d(42)
  let ok = noise3d_image(
    "./src/examples/color/basic/noise3d_color.png", 256, 256, 0.05, 0.3, 42, grads,
    false, false, 1.0,
  )
  assert_eq(ok, true)
}

test "3D fBm Noise Slice Image (Color)" {
  let config = new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = create3d(123)
  let ok = fbm3d_image(
    "./src/examples/color/fbm/noise3d_color.png", 256, 256, 0.3, 123, grads, config,
    false, false, 1.0,
  )
  assert_eq(ok, true)
}


test "3D Simplex Noise Slices Batch Output" {
  let (_, grads) = create3d(42)
  noise3d_slices(
    "./src/examples/slice_3d/gray/basic", 128, 128, 0.05, 42, grads, false, true,
    1.0, 10, // 切片数量
  )
}

test "3D fBm Noise Slices Batch Output" {
  let config = new_NoiseConfig(4, 0.5, 2.0, 0.03)
  let (_, grads) = create3d(123)
  fbm3d_slices(
    "./src/examples/slice_3d/gray/fbm", 128, 128, 123, grads, config, false, true,
    1.0, 10,
  )
}


test "3D Simplex Noise Slices Batch Output (Color)" {
  let (_, grads) = create3d(42)
  noise3d_slices(
    "./src/examples/slice_3d/color/basic", 128, 128, 0.05, 42, grads, false, false,
    1.0, 10,
  )
}


test "3D fBm Noise Slices Batch Output (Color)" {
  let config = new_NoiseConfig(4, 0.5, 2.0, 0.03)
  let (_, grads) = create3d(123)
  fbm3d_slices(
    "./src/examples/slice_3d/color/fbm", 128, 128, 123, grads, config, false, false,
    1.0, 10,
  )
}

test "Simplex Noise 3D - Output Range & Smoothness" {
  let (perm, grads) = create3d(42)
  let mut min_val = 1_000_000_000.0
  let mut max_val = -1_000_000_000.0
  let mut last = 0.0
  let mut diff_sum = 0.0
  let mut count = 0
  for x in 0..<10 {
    for y in 0..<10 {
      for z in 0..<10 {
        let val = @ZSeanYves/SimplexNoise.noise3d(
          [x.to_float(), y.to_float(), z.to_float()],
          perm,
          grads,
          0.1,
        )
        if val < min_val.to_float() {
          min_val = val.to_double()
        }
        if val > max_val.to_float() {
          max_val = val.to_double()
        }
        diff_sum += (val.to_double() - last).abs()
        last = val.to_double()
        count += 1
      }
    }
  }
  assert_eq(min_val >= -1.2 && max_val <= 1.2, true) // 合理范围
  assert_eq(diff_sum / count.to_double() < 0.5, true) // 平滑性
}

test "fBm Noise 3D - Output Range & Smoothness" {
  let config = new_NoiseConfig(4, 0.5, 2.0, 0.03)
  let (perm, grads) = create3d(42)
  let mut min_val = 1_000_000_000.0
  let mut max_val = -1_000_000_000.0
  let mut last = 0.0
  let mut diff_sum = 0.0
  let mut count = 0
  for x in 0..<10 {
    for y in 0..<10 {
      for z in 0..<10 {
        let val = @ZSeanYves/SimplexNoise.fbm3d(
          [x.to_float(), y.to_float(), z.to_float()],
          config.octaves,
          config.persistence,
          config.lacunarity,
          perm,
          grads,
          0.1,
        )
        if val < min_val.to_float() {
          min_val = val.to_double()
        }
        if val > max_val.to_float() {
          max_val = val.to_double()       }
        diff_sum += (val.to_double() - last).abs()
        last = val.to_double()
        count += 1
      }
    }
  }
  assert_eq(min_val >= -1.2 && max_val <= 1.2, true)
  assert_eq(diff_sum / count.to_double() < 0.5, true)
}
//
//
//
//
//
//
//
//
// 4D
test "4D Simplex Noise Slice Image" {
  let (_, grads) = @ZSeanYves/SimplexNoise.create4d(42)
  let ok = @ZSeanYves/SimplexNoise.noise4d_image(
    "./src/examples/gray/basic/noise4d.png", 256, 256, 0.05, 0.3, // z
     0.6, // w
     42, grads, false, true, 1.0,
  )
  assert_eq(ok, true)
}


test "4D fBm Noise Slice Image" {
  let config = new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = create4d(123)
  let ok = @ZSeanYves/SimplexNoise.fbm4d_image(
    "./src/examples/gray/fbm/noise4d.png", 256, 256, 0.3, 0.6, 123, grads, config,
    false, true, 1.0,
  )
  assert_eq(ok, true)
}

test "4D Simplex Noise Slice Image (Color)" {
  let (_, grads) = create4d(42)
  let ok = noise4d_image(
    "./src/examples/color/basic/noise4d_color.png", 256, 256, 0.05, 0.3, 0.6, 42,
    grads, false, false, 1.0,
  )
  assert_eq(ok, true)
}


test "4D fBm Noise Slice Image (Color)" {
  let config = new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = create4d(123)
  let ok = fbm4d_image(
    "./src/examples/color/fbm/noise4d_color.png", 256, 256, 0.3, 0.6, 123, grads,
    config, false, false, 1.0,
  )
  assert_eq(ok, true)
}


test "4D Simplex Noise Slices Batch Output" {
  let (_, grads) = create4d(42)
  noise4d_slices(
    "./src/examples/slice_4d/gray/basic", 128, 128, 0.05, 0.6, // 固定 w，切 z 轴
     42, grads, false, true, 1.0, 10,
  )
}


test "4D fBm Noise Slices Batch Output" {
  let config = new_NoiseConfig(4, 0.5, 2.0, 0.03)
  let (_, grads) = create4d(123)
  fbm4d_slices(
    "./src/examples/slice_4d/gray/fbm", 128, 128, 0.6, // 固定 w
     123, grads, config, false, true, 1.0, 10,
  )
}


test "4D Simplex Noise Slices Batch Output (Color)" {
  let (_, grads) = create4d(42)
  noise4d_slices(
    "./src/examples/slice_4d/color/basic", 128, 128, 0.05, 0.6, // 固定 w
     42, grads, false, false, 1.0, 10,
  )
}


test "4D fBm Noise Slices Batch Output (Color)" {
  let config = new_NoiseConfig(4, 0.5, 2.0, 0.03)
  let (_, grads) = create4d(123)
  fbm4d_slices(
    "./src/examples/slice_4d/color/fbm", 128, 128, 0.6, // 固定 w
     123, grads, config, false, false, 1.0, 10,
  )
}

test "Simplex Noise 4D - Output Range & Smoothness" {
  let (perm, grads) = create4d(123)
  let mut min_val = 1_000_000_000.0
  let mut max_val = -1_000_000_000.0
  let mut last = 0.0
  let mut diff_sum = 0.0
  let mut count = 0
  for x in 0..<6 {
    for y in 0..<6 {
      for z in 0..<6 {
        for w in 0..<6 {
          let val = @ZSeanYves/SimplexNoise.noise4d(
            [x.to_float(), y.to_float(), z.to_float(), w.to_float()],
            perm,
            grads,
            0.2,
          )
          if val < min_val.to_float() {
            min_val = val.to_double()
          }
          if val > max_val.to_float() {
            max_val = val.to_double()
          }
          diff_sum += (val.to_double() - last).abs()
          last = val.to_double()
          count += 1       }
      }
    }
  }
  assert_eq(min_val >= -1.2 && max_val <= 1.2, true)
  assert_eq(diff_sum / count.to_double() < 0.5, true)
}




test "fBm Noise 4D - Output Range & Smoothness" {
  let config = new_NoiseConfig(4, 0.5, 2.0, 0.03)
  let (perm, grads) = create4d(456)
  let mut min_val = 1_000_000_000.0
  let mut max_val = -1_000_000_000.0
  let mut last = 0.0
  let mut diff_sum = 0.0
  let mut count = 0
  for x in 0..<6 {
    for y in 0..<6 {
      for z in 0..<6 {
        for w in 0..<6 {
          let val = @ZSeanYves/SimplexNoise.fbm4d(
            [x.to_float(), y.to_float(), z.to_float(), w.to_float()],
            config.octaves,
            config.persistence,
            config.lacunarity,
            perm,
            grads,
            0.2,
          )
          if val < min_val.to_float() {
            min_val = val.to_double()
          }
          if val > max_val.to_float() {
            max_val = val.to_double()
          }
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

