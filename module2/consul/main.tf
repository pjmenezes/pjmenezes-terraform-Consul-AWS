##################################################################################
# PROVIDERS
##################################################################################

provider "consul" {
  address    = "127.0.0.1:8500" # IP E PORTA DO CONSUL
  datacenter = "dc1" #nome do meu datacenter
}

##################################################################################
# RESOURCES - criando as chaves valor
##################################################################################

resource "consul_keys" "networking" {
 
  key {
    path  = "networking/configuration/"
    value = ""
  }

  key {
    path  = "networking/state/"  #rede e estado para ser armazenado
    value = ""
  }
}

resource "consul_keys" "applications" {

  key {
    path  = "applications/configuration/"
    value = ""
  }

  key {
    path  = "applications/state/"
    value = ""
  }
}
# criando as politicas do networking e applications
resource "consul_acl_policy" "networking" {
  name  = "networking"
  rules = <<-RULE
    key_prefix "networking" {
      policy = "write"
    }

    session_prefix "" {
      policy = "write"
    }
    RULE
}

resource "consul_acl_policy" "applications" {
  name  = "applications"
  rules = <<-RULE
    key_prefix "applications" {
      policy = "write"  #acesso a gravação
    }

    key_prefix "networking/state" {
      policy = "read"   # a leitura dos estados da rede
    }

    session_prefix "" {
      policy = "write"   #estabelecer a seção
    }

    RULE
}
 # gerar a conta para os admins
resource "consul_acl_token" "pedro" {
  description = "token for Pedro Menezes"
  policies    = [consul_acl_policy.networking.name]
}

resource "consul_acl_token" "alessandra" {
  description = "token for Alessandra Pena"
  policies    = [consul_acl_policy.applications.name]
}

##################################################################################
# OUTPUTS - GERANDO ID PARA ACESSO PARA AMBOS - [TOKEN]
##################################################################################

output "pedro_token_accessor_id" {
  value = consul_acl_token.pedro.id
}

output "alessandra_token_accessor_id" {
  value = consul_acl_token.alessandra.id
}