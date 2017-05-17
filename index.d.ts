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
		definition(): any; // Promise
		insert(definition, data, autosave?): any; // Promise
		all(refresh, pluck?): any; // Promise
		at(index): Document;
		sync(): any; // Promise
	}
	export class Document {
		constructor(custodian: Custodian, key: string);
		fetch(): any; // Promise
		link(key, data): any; // Promise
		definition(definition?: Definition): any; // Promise
		validate(): any; // Promise
		data(data, alg?: string): any; // Promise
		encrypt(data, alg?: string): any; // Promise
		decrypt(): any; // Promise
		validate(): any; // Promise
		meta(): any; // Promise
		summary(): any; // Promise
		details(): any;  // Promise
		save(): any; // Promise
	}
	export class Definition {
		constructor(custodian: Custodian, definition: Definition);
		child(key): any; // Promise
		children(): any; // Promise
		get(key): any; // Promise
		bundle(definition: Definition): any; // Promise
		schema(schema): any; // Promise
	}
	export class Custodian {
		constructor(config?: Object);
		config: Object;
		store: any; // storageEngine
		data: any; // Datastore
		document: any; // Documentstore
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
