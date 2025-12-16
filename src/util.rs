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

pub struct Grid<T> {
    pub data: Vec<T>,
    pub rows: usize,
    pub cols: usize,
    pub default: T,
}

impl<T: Clone> Grid<T> {
    pub fn new(rows: usize, cols: usize, default: T) -> Self {
        let default_clone = default.clone();
        Grid {
            data: vec![default; rows * cols],
            rows,
            cols,
            default: default_clone,
        }
    }
    
    pub fn get(&self, row: usize, col: usize) -> &T {
        if row < self.rows && col < self.cols {
            &self.data[row * self.cols + col]
        } else {
            &self.default
        }
    }
    
    pub fn set(&mut self, row: usize, col: usize, value: T) {
        if row < self.rows && col < self.cols {
            self.data[row * self.cols + col] = value;
        }
    }
}