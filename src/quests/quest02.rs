use crate::util;

struct RuneState{
    rune: Vec<u8>,
    position: usize,
}

#[inline]
fn count_runic_occurrences(runic: &[&str], word: &str) -> usize {
    runic.iter()
         .filter(|&&r| word.contains(r))
         .count()
}

fn count_runic_in_phrase(runic: &mut [RuneState], phrase: &[&str]) -> usize {
    let mut count = 0usize;
    for curr in phrase.iter().flat_map(|&w| w.bytes()) {
        for rune_state in runic.iter_mut() {
            if rune_state.position < rune_state.rune.len() && curr == rune_state.rune[rune_state.position] {
                rune_state.position += 1;
                if rune_state.position == rune_state.rune.len() {
                    count += rune_state.position;
                    rune_state.position = 0;
                }
            }
            else {
                rune_state.position = 0;
            }
        }
    }
    count
}

fn reset_states(runic: &mut [RuneState]) {
    for rune_state in runic.iter_mut() {
        rune_state.position = 0;
    }
}

fn get_runic(line: &str) -> Vec<&str> {
    line.split_once(':')
        .map(|(_, runic)| runic.split(',').collect::<Vec<&str>>())
        .unwrap_or_default()
}

fn get_runic_structs(line: &str) -> Vec<RuneState> {
    let runes = get_runic(line);
    let forward= 
            runes.iter().map(|x| RuneState{rune: x.as_bytes().to_vec(), position : 0usize});
    let backward = 
            runes.iter().map(|x| RuneState{rune: x.bytes().rev().collect(), position : 0usize});
    forward.chain(backward).collect()
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
    let mut runic= get_runic_structs(&lines[0]);

    let phrases = lines[2..].iter().map(|line| line.split(' ').collect::<Vec<&str>>());
    let mut total = 0usize;
    for phrase in phrases {
        total += count_runic_in_phrase(&mut runic, &phrase);
        reset_states(&mut runic);
    }
    total.to_string()
}

fn part3() -> String {
    "Elefante".to_string()
}

pub fn solve(part: u32) -> String {
    match part {
        1 => part1(),
        2 => part2(),
        3 => part3(),
        _ => "Invalid part".to_string(),
    }
}