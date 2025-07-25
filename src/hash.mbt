// 初始化置换表，基于种子打乱
fn init_noise(seed: Int) -> Array[Int] {
  let perm_table = init_permutation(seed)
  
  //重复一遍 0..255 填充，构建最终长度 512 的置换表
  let result = [..perm_table, ..perm_table]
  result
}
fn hash(
  ix : Int,
  iy : Int,
  perm_table : Array[Int],
  grads : Array[Array[Float]]
) -> Array[Float] {
  let idx = perm_table[(perm_table[ix & 511] + iy) & 511] % grads.length()
  grads[idx]
}


fn hash3d(
  ix : Int,
  iy : Int,
  iz : Int,
  perm_table : Array[Int],
  grads : Array[Array[Float]]
) -> Array[Float] {
  let idx = perm_table[(perm_table[(perm_table[ix & 511] + iy) & 511] + iz) &
    511] %
    grads.length()
  grads[idx]
}

fn hash4d(
  ix : Int,
  iy : Int,
  iz : Int,
  iw : Int,
  perm_table : Array[Int],
  grads : Array[Array[Float]]
) -> Array[Float] {
  let idx = perm_table[(
      perm_table[(perm_table[(perm_table[ix & 511] + iy) & 511] + iz) & 511] +
      iw
    ) &
    511] %
    grads.length()
  grads[idx]
}



