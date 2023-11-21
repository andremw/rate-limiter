open Jest
open Expect

open Utils

test("timeDiffInSeconds", () => {
  let date1 = Date.makeWithYMDHMS(
    ~year=2023,
    ~month=10,
    ~date=21,
    ~hours=12,
    ~minutes=0,
    ~seconds=0,
  )
  let date2 = Date.makeWithYMDHMS(
    ~year=2023,
    ~month=10,
    ~date=21,
    ~hours=12,
    ~minutes=0,
    ~seconds=10,
  )

  timeDiffInSeconds(date1, date2)->expect->toBe(10)
})

test("limit", () => {
  let limit10 = limitTo(10)
  limit10(100)->expect->toBe(10)
})
