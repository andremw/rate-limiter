let timeDiffInSeconds = (date1, date2) =>
  Math.abs(date1->Date.getTime -. date2->Date.getTime)->Float.toInt / 1000

let limitTo = (max, value) =>
  Math.max(0.0, Math.min(max->Int.toFloat, value->Int.toFloat))->Float.toInt
