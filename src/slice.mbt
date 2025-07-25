priv suberror Slice String

pub fn noise3d_slices(
  base_path : String,
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  grads : Array[Array[Float]],
  useWarp : Bool,
  isGrayScale : Bool,
  strength~ : Float = 1.0,
  slice_count : Int
) -> Unit raise Error {
  for i in 0..<slice_count {
    let z = i.to_float() / slice_count.to_float()
    let path = base_path + "/slice_\{i}.png"
    let ok = noise3d_image(
      path,
      width,
      height,
      scale,
      z,
      seed,
      grads,
      useWarp,
      isGrayScale,
      strength~,
    )
    if not(ok) {
      raise Slice("Failed to save slice \{i}")
    }
  }
}

pub fn fbm3d_slices(
  base_path : String,
  width : Int,
  height : Int,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig,
  useWarp : Bool,
  isGrayScale : Bool,
  strength~ : Float = 1.0,
  slice_count : Int
) -> Unit raise Error {
  for i in 0..<slice_count {
    let z = i.to_float() / slice_count.to_float()
    let path = base_path + "/fbm_slice_\{i}.png"
    let ok = fbm3d_image(
      path,
      width,
      height,
      z,
      seed,
      grads,
      config,
      useWarp,
      isGrayScale,
      strength~,
    )
    if not(ok) {
      raise Slice("Failed to save fBm slice \{i}")
    }
  }
}


pub fn noise4d_slices(
  base_path : String,
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]],
  useWarp : Bool,
  isGrayScale : Bool,
  strength~ : Float = 1.0,
  slice_count : Int
) -> Unit raise Error {
  for i in 0..<slice_count {
    let w = i.to_float() / slice_count.to_float()
    let path = base_path + "/slice_\{i}.png"
    let ok = noise4d_image(
      path,
      width,
      height,
      scale,
      z,
      w,
      seed,
      grads,
      useWarp,
      isGrayScale,
      strength~,
    )
    if not(ok) {
      raise Slice("Failed to save slice \{i}")
    }
  }
}


pub fn fbm4d_slices(
  base_path : String,
  width : Int,
  height : Int,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig,
  useWarp : Bool,
  isGrayScale : Bool,
  strength~ : Float = 1.0,
  slice_count : Int
) -> Unit raise Error {
  for i in 0..<slice_count {
    let w = i.to_float() / slice_count.to_float()
    let path = base_path + "/fbm_slice_\{i}.png"
    let ok = fbm4d_image(
      path,
      width,
      height,
      z,
      w,
      seed,
      grads,
      config,
      useWarp,
      isGrayScale,
      strength~,
    )
    if not(ok) {
      raise Slice("Failed to save fBm slice \{i}")
    }
  }
}


