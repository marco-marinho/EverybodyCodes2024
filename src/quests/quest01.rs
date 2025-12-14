use crate::util;

#[inline]
fn get_score(x: u8) -> u32 {
    match x {
        b'B' => 1,
        b'C' => 3,
        b'D' => 5,
         _ => 0,
    }
}

fn solve_chunked(line: &str, chunk_size: usize) -> String {
    line.as_bytes()
        .chunks(chunk_size) 
        .map( |chunk| {
            let monster_count = chunk.iter().filter(|&&c| c != b'x').count() as i32;
            let bonus = (monster_count * (monster_count - 1)) as u32;
            chunk.iter().map(|&c| get_score(c)).sum::<u32>() + bonus
        }
    )
    .sum::<u32>()
    .to_string()
}

pub fn part1() -> String {
    let line = &util::read_day(1, 1)[0];
    solve_chunked(line, 1)
}

pub fn part2() -> String {
    let line = &util::read_day(1, 2)[0];
    solve_chunked(line, 2)
}

pub fn part3() -> String {
    let line = &util::read_day(1, 3)[0];
    solve_chunked(line, 3)
}

pub fn solve(part: u32) -> String {
    match part {
        1 => part1(),
        2 => part2(),
        3 => part3(),
        _ => "Invalid part".to_string(),
    }
}