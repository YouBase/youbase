// Type definitions for YouBase 0.1.10
// Project: YouBase
// Definitions by: Justin Laue <https://github.com/fp-x>

declare class Wallet {
    coin: string;
}

declare class Document {
}

declare class Definition {
}

declare class Collection {
}

declare class Custodian {
}

export class YouBase {
    constructor(custodian?: string);

    wallet: Wallet;
    document: Document;
    definition: Definition;
    collection: Collection;
    custodian: Custodian;
}


