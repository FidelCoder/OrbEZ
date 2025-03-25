use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub struct OrbEZWallet {
    owner: String,
    balance: u64,
}

#[wasm_bindgen]
impl OrbEZWallet {
    #[wasm_bindgen(constructor)]
    pub fn new(owner: String) -> OrbEZWallet {
        OrbEZWallet { owner, balance: 0 }
    }

    pub fn send_funds(&mut self, amount: u64, currency: String) -> bool {
        if self.balance >= amount {
            self.balance -= amount;
            // Call EVM contract via WASM bindings (TBD)
            true
        } else {
            false
        }
    }
}