//
//  FCollectionReference.swift
//  ChitChat
//
//  Created by wingswift on 2021-12-08.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
}

func firebaseReference(_ reference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(reference.rawValue)
}
