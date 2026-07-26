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
//! Declaration and implementation of serializables

/// Represents a rarity
#[derive(
    PartialEq, Eq, PartialOrd, Ord, Debug, serde_repr::Deserialize_repr, serde_repr::Serialize_repr,
)]
#[repr(u8)]
pub enum Rarity {
    Common = 0,
    Uncommon = 1,
    Super = 2,
    Extreme = 3,
    Ultra = 4,
    Kami = 5,
}

/// Represents a character
#[derive(Debug, serde::Deserialize)]
pub struct Character {
    id: u32,
    name: String,
    rarity: Rarity,
}

impl Character {
    /// Creates a new character
    pub fn new(id: u32, name: String, rarity: Rarity) -> Self {
        Character { id, name, rarity }
    }

    pub fn id(&self) -> u32 {
        self.id
    }

    pub fn name(&self) -> &str {
        &self.name
    }

    pub fn rarity(&self) -> &Rarity {
        &self.rarity
    }
}
