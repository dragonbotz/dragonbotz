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
//! dragonbotz entrypoint
pub mod core;
pub mod models;
pub mod services;

use tonic::transport::Server;
use tracing::{debug, info};
use tracing_subscriber;

use crate::services::summon::{Summon, grpc_summon::summon_service_server::SummonServiceServer};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    tracing_subscriber::fmt()
        .with_max_level(tracing::Level::DEBUG)
        .init();

    info!("🐉🔮 Dragon Bot Z - Engine 🔮🐉");

    info!("⏳ Initializing gRPC services...");
    let summon = Summon::default();
    info!("✅ gRPC services intialized");

    info!("⏳ Loading characters...");
    let characters =
        core::characters::load_characters(std::path::Path::new("res/assets/characters"))?;
    info!("✅ Characters loaded: {}", characters.iter().count());

    info!("🚀 Now running");
    let addr: std::net::SocketAddr = "127.0.0.1:58180".parse()?;
    info!("🌐 Listening address set to: {}", addr);

    Server::builder()
        .add_service(SummonServiceServer::new(summon))
        .serve(addr)
        .await?;

    Ok(())
}
