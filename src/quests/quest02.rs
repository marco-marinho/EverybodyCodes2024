use crate::util;


#[inline]
fn count_runic_occurrences(runic: &[&str], word: &str) -> usize {
    runic.iter()
         .filter(|&&r| word.contains(r))
         .count()
}


fn get_runic(line: &str) -> Vec<&str> {
    line.split_once(':')
        .map(|(_, runic)| runic.split(',').collect::<Vec<&str>>())
        .unwrap_or_default()
}

fn get_runic_as_bytes(line: &str) -> Vec<Vec<u8>> {
    let runes = get_runic(line);
    let forward= 
            runes.iter().map(|x| x.as_bytes().to_vec());
    let backward = 
            runes.iter().map(|x| x.bytes().rev().collect());
    forward.chain(backward).collect()
}

fn count_runnic_chars(runic: &[Vec<u8>], phrase: &[u8]) -> usize {
    let mut flags = vec![false; phrase.len()];
    for i in 0..phrase.len(){
        for rune in runic {
            if phrase[i..].starts_with(rune) {
                for j in 0..rune.len() {
                    flags[i + j] = true;
                }
            }
        }
    }
    flags.iter().filter(|&&f| f).count()
}

fn count_runnic_circular(runic: &[Vec<u8>], phrases: &[u8], rows: usize, cols: usize) -> usize {
    let mut grid = vec![false; rows * cols];
    for row in 0 .. rows{
        for col in 0 .. cols{
            for rune in runic {
                for j in 0..rune.len() {
                    let idx = (col + j) % cols;
                    if phrases[row * cols + idx] != rune[j] {
                        break;
                    }
                    if j == rune.len() - 1 {
                        for k in 0..rune.len() {
                            let flag_idx = (col + k) % cols;
                            grid[row * cols + flag_idx] = true;
                        }
                    }
                }
                if rune.len() > rows - row {
                    continue;
                }
                for j in 0..rune.len() {
                    if phrases[(row + j) * cols + col] != rune[j] {
                        break;
                    }
                    if j == rune.len() - 1 {
                        for k in 0..rune.len() {
                            grid[(row + k) * cols + col] = true;
                        }
                    }
                }
            }
        }
    }
    grid.iter().filter(|&&f| f).count()
}

fn lines_to_grid(phrases: &Vec<Vec<u8>>) -> (Vec<u8>, usize, usize) {
    let rows = phrases.len();
    let cols = phrases[0].len();
    let mut grid = vec![0u8; rows * cols];
    for row in 0..rows {
        for col in 0..cols {
            grid[row * cols + col] = phrases[row][col];
        }
    }
    (grid, rows, cols)
}

fn part1() -> String {
    let lines = &util::read_day(2, 1);
    let runic = get_runic(&lines[0]);
    let words = lines[2].split(' ').collect::<Vec<&str>>();
    words.iter().fold(0, |acc, &word| acc + count_runic_occurrences(&runic, word))
         .to_string()
}


fn part2() -> String {
    let lines = &util::read_day(2, 2);
    let runic= get_runic_as_bytes(&lines[0]);

    let total_count = lines.iter()
                             .map(|line| count_runnic_chars(&runic, line.as_bytes()))
                             .sum::<usize>();
    total_count.to_string()
}

fn part3() -> String {
    let lines = &util::read_day(2,3);
    let runic= get_runic_as_bytes(&lines[0]);
    let phrases: Vec<Vec<u8>> = lines[2..].iter().map(|line| line.bytes().collect()).collect();
    let (phrases_grid, rows, cols) = lines_to_grid(&phrases);
    let count_rows = count_runnic_circular(&runic, &phrases_grid, rows, cols);
    count_rows.to_string()
}

pub fn solve(part: u32) -> String {
    match part {
        1 => part1(),
        2 => part2(),
        3 => part3(),
        _ => "Invalid part".to_string(),
    }
}