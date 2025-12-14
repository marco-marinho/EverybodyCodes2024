use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

pub fn read_lines(filename: &str) -> Vec<String> {
    let path = Path::new(filename);
    match File::open(&path) {
        Ok(file) => {
            let buf = io::BufReader::new(file);
            buf.lines().filter_map(Result::ok).collect()
        }
        Err(_) => vec!["Error".to_string()],
    }
}

pub fn read_day(day: u32, part: u32) -> Vec<String> {
    let filename = format!("data/quest{:02}_{}.txt", day, part);
    read_lines(&filename)
}