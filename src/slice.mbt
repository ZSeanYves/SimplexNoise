priv suberror Slice String

pub fn generate_3d_slices(
  base_path : String,
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  grads : Array[Array[Float]],
  slice_count : Int
) -> Unit raise Error {
  for i in 0..<slice_count {
    let z = i.to_float() / slice_count.to_float()
    let path = base_path + "/slice_\{i}.png"
    let ok = generate_and_save_noise3d_image(path, width, height, scale, z, seed, grads)
    if not(ok) {
      raise Slice("Failed to save slice \{i}")
    }
  }
}

pub fn generate_fbm3d_slices(
  base_path : String,
  width : Int,
  height : Int,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig,
  slice_count : Int
) -> Unit raise Error {
  for i in 0..<slice_count {
    let z = i.to_float() / slice_count.to_float()
    let path = base_path + "/fbm_slice_\{i}.png"
    let ok = generate_and_save_fbm3d_image(path, width, height, z, seed, grads, config)
    if not(ok) {
      raise Slice("Failed to save fBm slice \{i}")
    }
  }
}

pub fn generate_3d_slices_color(
  base_path : String,
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  grads : Array[Array[Float]],
  slice_count : Int
) -> Unit raise Error {
  for i in 0..<slice_count {
    let z = i.to_float() / slice_count.to_float()
    let path = base_path + "/slice_\{i}.png"
    let ok = generate_and_save_noise3d_image_color(path, width, height, scale, z, seed, grads)
    if not(ok) {
      raise Slice("Failed to save slice \{i}")
    }
  }
}

pub fn generate_fbm3d_slices_color(
  base_path : String,
  width : Int,
  height : Int,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig,
  slice_count : Int
) -> Unit raise Error {
  for i in 0..<slice_count {
    let z = i.to_float() / slice_count.to_float()
    let path = base_path + "/fbm_slice_\{i}.png"
    let ok = generate_and_save_fbm3d_image_color(path, width, height, z, seed, grads, config)
    if not(ok) {
      raise Slice("Failed to save fBm slice \{i}")
    }
  }
}

pub fn generate_4d_slices(
  base_path : String,
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]],
  slice_count : Int
) -> Unit raise Error {
  for i in 0..<slice_count {
    let w = i.to_float() / slice_count.to_float()
    let path = base_path + "/slice_\{i}.png"
    let ok = generate_and_save_noise4d_image(path, width, height, scale, z, w, seed, grads)
    if not(ok) {
      raise Slice("Failed to save slice \{i}")
    }
  }
}


pub fn generate_fbm4d_slices(
  base_path : String,
  width : Int,
  height : Int,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig,
  slice_count : Int
) -> Unit raise Error {
  for i in 0..<slice_count {
    let w = i.to_float() / slice_count.to_float()
    let path = base_path + "/fbm_slice_\{i}.png"
    let ok = generate_and_save_fbm4d_image(path, width, height, z, w, seed, grads, config)
    if not(ok) {
      raise Slice("Failed to save fBm slice \{i}")
    }
  }
}


pub fn generate_4d_slices_color(
  base_path : String,
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]],
  slice_count : Int
) -> Unit raise Error {
  for i in 0..<slice_count {
    let w = i.to_float() / slice_count.to_float()
    let path = base_path + "/slice_\{i}.png"
    let ok = generate_and_save_noise4d_image_color(path, width, height, scale, z, w, seed, grads)
    if not(ok) {
      raise Slice("Failed to save slice \{i}")
    }
  }
}

pub fn generate_fbm4d_slices_color(
  base_path : String,
  width : Int,
  height : Int,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig,
  slice_count : Int
) -> Unit raise Error {
  for i in 0..<slice_count {
    let w = i.to_float() / slice_count.to_float()
    let path = base_path + "/fbm_slice_\{i}.png"
    let ok = generate_and_save_fbm4d_image_color(path, width, height, z, w, seed, grads, config)
    if not(ok) {
      raise Slice("Failed to save fBm slice \{i}")
    }
  }
}
