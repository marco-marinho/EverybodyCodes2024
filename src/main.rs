mod quests;
mod util;

fn main() {    
    
    let args: Vec<String> = std::env::args().collect();
    
    if args.len() < 3 {
        eprintln!("Usage: {} <arg1> <arg2>", args[0]);
        std::process::exit(1);
    }
    
    let day = &args[1].parse::<u32>().expect("Invalid day number");
    let part = &args[2].parse::<u32>().expect("Invalid part number");

    match (day, part) {
        (1, _) => {
            let result = quests::quest01::solve(*part);
            println!("Quest {}, Part {}: {}",day, part, result);
        }
        _ => {
            eprintln!("No implementation for Quest {} Part {}", day, part);
            std::process::exit(1);
        }
    }   

}
