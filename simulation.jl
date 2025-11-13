module Simulation

using Random
using LinearAlgebra

include("Friendships.jl")
using .Friendships

export simulate!

"""
    simulate!(people; steps=100, α=0.6, β=0.25, γ=0.1, seuil=0.7)

Simule l’évolution sociale :
1. Mise à jour des intensités relationnelles via `poidsM`
2. Mise à jour des amitiés selon intensité
3. Influence émotionnelle entre amis forts
"""
function simulate!(people::Population;
                   steps=100,
                   α=0.6, β=0.25, γ=0.1,
                   seuil=0.7)

    # On initialise les intensités du module Friendships
    poids = poids0(people)

    for t in 1:steps

        # 1️⃣ Mise à jour des intensités (Friendships)
        poidsM(poids, people; alpha=α, beta=β, gamma=γ)

        # 2️⃣ Mise à jour automatique des amitiés
        for ((i,j), (intensite, _)) in poids
            if intensite > seuil
                # ils deviennent amis si ce n'est pas déjà le cas
                people[i].friends = union(people[i].friends, [j])
                people[j].friends = union(people[j].friends, [i])
            else
                # amitié trop faible : rupture possible
                people[i].friends = setdiff(people[i].friends, [j])
                people[j].friends = setdiff(people[j].friends, [i])
            end
        end

        # 3️⃣ Influence émotionnelle entre amis forts
        for ((i,j), (intensite,_)) in poids
            if intensite > seuil
                influence!(people[i], people[j], poids; alpha=α, beta=β, gamma=γ)
            end
        end
    end

    return poids
end

end
