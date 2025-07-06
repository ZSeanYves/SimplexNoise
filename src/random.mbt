// 简单的线性同余生成器
fn random_int(seed: Int) -> Int {
  (seed * 1103515245 + 12345) & 0x7fffffff
}

// 自定义洗牌，基于 seed 控制随机性
fn shuffle(arr: Array[Int], seed: Int) -> Array[Int] {
  let result = [..arr]  // 深拷贝
  let mut s = seed
  let n = result.length()

  let mut i = n - 1
  while i >= 0 {
    s = random_int(s)
    let j = s % (i + 1)
    let temp = result[i]
    result[i] = result[j]
    result[j] = temp

    if i == 0 { break }
    i = i - 1
  }
  result
}


fn make_range(start: Int, end: Int) -> Array[Int] {
  if start > end {
    []
  } else {
    [start, ..make_range(start + 1, end)]
  }
}


// 初始化置换表
fn init_permutation(seed: Int) -> Array[Int] {
  let base = make_range(0, 255)
  let shuffled = shuffle(base, seed)
  // 直接返回洗牌后的数组作为置换表
  shuffled
}
