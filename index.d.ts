// Type definitions for YouBase 0.1.10
// Project: YouBase
// Definitions by: Justin Laue <https://github.com/fp-x>


declare namespace YouBase {
	export class Wallet {
		constructor(custodian: Custodian, mnemonic?: string, config?: Object);
		custodian: Custodian;
		mnemonic: string;
		coin: string;
		config: Object;
		seed: string;
		rootkey: string;
		hdkey: string;
		privateExtendedKey: string;
		profiles: Collection;
		static generateMnemonic(): string;
	}
	export class Collection {
		constructor(custodian: Custodian, model: string, key: string, hardened?: boolean)
		definition(): number;
		all(refresh, pluck?): any; // change to Promise?
    insert(definition, data, autosave?): any;
	}

	export interface Document {
	}
	export interface Definition {
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
