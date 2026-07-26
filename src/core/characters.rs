//! dragonbotz - The Dragon Ball text-based gacha game
//! Copyright (C) 2019  Crocomango
//!
//! This program is free software: you can redistribute it and/or modify
//! it under the terms of the GNU General Public License as published by
//! the Free Software Foundation, either version 3 of the License, or
//! (at your option) any later version.
//!
//! This program is distributed in the hope that it will be useful,
//! but WITHOUT ANY WARRANTY; without even the implied warranty of
//! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//! GNU General Public License for more details.
//!
//! You should have received a copy of the GNU General Public License
//! along with this program.  If not, see <https://www.gnu.org/licenses/>.
//! ---
//! Core functionnality related to characters
use anyhow::anyhow;

use crate::models;

/// Loads all character definitions from YAML files in the specified directory.
///
/// Each valid YAML file is deserialized into a [`crate::models::Character`] instance.
///
/// # Arguments
///
/// * `path` - Path to the directory containing character YAML definition files
///
/// * `Result<Vec<models::Character>, anyhow::Error>` - A vector of parsed [`crate::models::Character`] instances on success,
///   or an error if loading or parsing fails
///
/// # Errors
///
/// Returns an error in the following cases:
///
/// * The provided path does not exist
/// * The provided path is not a directory
/// * A file cannot be parsed as valid YAML into a [`crate::models::Character`]
pub fn load_characters(path: &std::path::Path) -> anyhow::Result<Vec<models::Character>> {
    // check if path exists
    if !path.exists() {
        return Err(anyhow!("Given path does not exist"));
    }

    // check if the path is a directory ; if not, return an error
    if !path.is_dir() {
        return Err(anyhow!("Given path is not a directory"));
    }

    let mut characters = Vec::new();
    for entry in std::fs::read_dir(path)? {
        let entry = entry?;
        if !entry.file_type()?.is_file() {
            continue;
        }

        let file = std::fs::File::open(entry.path())?;
        let character: models::Character = yaml_serde::from_reader(file)?;
        characters.push(character);
    }

    if characters.is_empty() {
        return Err(anyhow!("The directory is empty or contains no valid files"));
    }

    Ok(characters)
}
