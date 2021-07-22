//
//  File.swift
//  
//
//  Created by Mike Muszynski on 6/27/21.
//

import Combine

struct Paginate<Upstream: Publisher>: Publisher {
    typealias Output = Upstream.Output
    typealias Failure = Upstream.Failure
    
    public typealias NextPageStrategy = (Upstream.Output) -> Upstream?
    let nextPageStrategy: NextPageStrategy
    
    let upstream: Upstream
    init(_ upstream: Upstream, strategy: @escaping NextPageStrategy) {
        self.upstream = upstream
        self.nextPageStrategy = strategy
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = PaginateSubscription(upstream: self.upstream, subscriber: subscriber, strategy: nextPageStrategy)
        subscriber.receive(subscription: subscription)
    }
}

extension Paginate {
    class PaginateSubscription<Downstream: Subscriber>: Subscription, Subscriber where Downstream.Input == Upstream.Output, Downstream.Failure == Upstream.Failure {
        typealias Input = Upstream.Output
        typealias Failure = Upstream.Failure
        
        var downstream: Downstream
        var upstream: Upstream
        private var toUpstream: Subscription?
        
        private var latestValue: Upstream.Output?
        private var remainingDemand: Subscribers.Demand = .none
        
        private let nextPageStrategy: NextPageStrategy
        
        init(upstream: Upstream, subscriber: Downstream, strategy: @escaping NextPageStrategy) {
            self.downstream = subscriber
            self.upstream = upstream
            self.nextPageStrategy = strategy
            
            upstream.subscribe(self)
        }
        
        func request(_ demand: Subscribers.Demand) {
            self.remainingDemand += demand
            toUpstream?.request(self.remainingDemand)
        }
        
        func cancel() {
        }
        
        func receive(subscription: Subscription) {
            self.toUpstream = subscription
        }
        
        func receive(_ input: Upstream.Output) -> Subscribers.Demand {
            //Propogate the input downstream
            latestValue = input
            let nextDemand = downstream.receive(input)
            self.remainingDemand += nextDemand
            return nextDemand
        }
        
        func receive(completion: Subscribers.Completion<Upstream.Failure>) {
            switch completion {
            case .failure(let error):
                //If the upstream ever fails, propogate the error downstream
                downstream.receive(completion: .failure(error))
            case .finished:
                //If the upstream subscription is finished, replace the upstream with a new publisher
                //Currently there's no way to do this
                //Otherwise, propogate the completion to the downstream
                guard let latest = latestValue else {
                    downstream.receive(completion: .finished)
                    return
                }
                
                if let new = nextPageStrategy(latest) {
                    self.upstream = new
                    new.subscribe(self)
                    self.request(self.remainingDemand)
                } else {
                    downstream.receive(completion: .finished)
                }
            }
        }
    }
}

extension Publisher {
    func paginate(strategy: @escaping Paginate<Self>.NextPageStrategy) -> Paginate<Self> {
        return Paginate(self, strategy: strategy)
    }
}
