// Type definitions for YouBase 0.1.10
// Project: YouBase
// Definitions by: Justin Laue <https://github.com/fp-x>


declare namespace YouBase {
	export class Wallet {
		constructor(custodian?: string);
		custodian: Custodian;
		mnemonic: string;
		coin: string;
		config: Object;
		seed: string;
	}
	export interface Document {
	}
	export interface Definition {
	}
	export interface Collection {
	}
	export interface Custodian {
	}
}

declare class YouBase {
	constructor(custodian?: string);

	wallet: YouBase.Wallet;
	document: YouBase.Document;
	definition: YouBase.Definition;
	collection: YouBase.Collection;
	custodian: YouBase.Custodian;
}

export = YouBase;
export as namespace YouBase;