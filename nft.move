
/// Module: nft
module nft::nft;
//Import modules
use std::string;
use sui::{url::{Self, Url}};

/// An example NFT that can be minted by anybody
public struct 	StekaNFT has key, store {
		id: UID,
		name: string::String,
		description: string::String,
		url: Url,
		// TODO: allow custom attributes
}


// ===== Public view functions =====

/// Get the NFT's `name`
public fun name(nft: &StekaNFT): &string::String {
		&nft.name
}

/// Get the NFT's `description`
public fun description(nft: &StekaNFT): &string::String {
		&nft.description
}

/// Get the NFT's `url`
public fun url(nft: &StekaNFT): &Url {
		&nft.url
}

// ===== Entrypoints =====

#[allow(lint(self_transfer))]
/// Create a new devnet_nft
public entry fun mint_to_sender(
		name: vector<u8>,
		description: vector<u8>,
		url: vector<u8>,
		ctx: &mut TxContext,
) {
		let sender = ctx.sender();
		let nft = StekaNFT {
				id: object::new(ctx),
				name: string::utf8(name),
				description: string::utf8(description),
				url: url::new_unsafe_from_bytes(url),
		};
		transfer::public_transfer(nft, sender);
}

/// Transfer `nft` to `recipient`
public entry fun transfer(nft: StekaNFT, recipient: address, _: &mut TxContext) {
		transfer::public_transfer(nft, recipient)
}

/// Update the `description` of `nft` to `new_description`
public entry fun update_description(
		nft: &mut StekaNFT,
		new_description: vector<u8>,
		_: &mut TxContext,
) {
		nft.description = string::utf8(new_description)
}

/// Permanently delete `nft`
public entry fun burn(nft: StekaNFT, _: &mut TxContext) {
		let StekaNFT { id, name: _, description: _, url: _ } = nft;
		id.delete()
}