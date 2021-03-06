//
//  GraphQLFactoryProtocol.swift
//  CyclePath
//
//  Created by Guillaume Loulier on 07/11/2017.
//  Copyright © 2017 Guillaume Loulier. All rights reserved.
//

import Apollo
import Foundation

protocol GraphQLFactoryProtocol
{
    func getClient(url: String) -> ApolloClient
}
