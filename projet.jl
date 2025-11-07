# projet.jl

# Charger les modules
include("Friendships.jl")
include("Simulation.jl")

# Les activer
using .Friendships
using .Simulation

# Créer la population
people = Population(10)
println("Population créée !")

# Créer les relations initiales
relations = init_friendships(people)
println("Relations initialisées :", length(relations))

# Lancer la simulation
simulate!(people, relations, 100)
println("Simulation terminée !")

# Afficher quelques scores d'amitié
println("Scores finaux : ", [r.score for r in relations[1:5]])

