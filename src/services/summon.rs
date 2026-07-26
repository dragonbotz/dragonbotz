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
//! Implementation of the summon service

use tonic::{Request, Response, Status};
use tracing::info;

use grpc_summon::summon_service_server::{SummonService, SummonServiceServer};
use grpc_summon::{SummonOneRequest, SummonOneResponse};

pub mod grpc_summon {
    tonic::include_proto!("summon");
}

#[derive(Debug, Default)]
pub struct Summon {}

#[tonic::async_trait]
impl SummonService for Summon {
    async fn summon_one(
        &self,
        request: Request<SummonOneRequest>,
    ) -> Result<Response<SummonOneResponse>, Status> {
        info!("Hello!");

        let response = SummonOneResponse {};

        Ok(Response::new(response))
    }
}
