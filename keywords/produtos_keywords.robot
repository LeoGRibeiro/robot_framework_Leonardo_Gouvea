* Settings *
Documentation          Keywords relacionados a Produtoss

Resource            ../support/common/common.robot
Resource            ../support/fixtures/dynamics.robot

* Keywords *
# GET KEYWORDS #######################################################################################################
GET Endpoint /produtos
    ${response}         GET on Session      serverest   /produtos  
    Set Global Variable  ${response}  
    Log to Console      Response: ${response.content}
    Log to Console      Quantidade: ${response.json()["quantidade"]}

GET Endpoint /produtos por ID 
    ${response}         GET on Session      serverest   /produtos/${id_produto}        expected_status=any       
    Set Global Variable  ${response}  
    Log to Console      Response: ${response.content}

# POST KEYWORDS #######################################################################################################
POST Endpoint /produtos
    &{header}           Create Dictionary       Authorization=${token_auth}      
    ${response}         POST on Session         serverest       /produtos       data=&{payload}                  headers=${header}          expected_status=any
    Log to Console      ${payload}
    Log to Console      Response: ${response.content}  
    Set Global Variable     ${response}

# PUT KEYWORDS #######################################################################################################
PUT Endpoint /produtos
    ${response}         GET on Session      serverest   /produtos/${id_produto}        expected_status=any 
    Log to Console      Antigo Produto: ${response.content}
    &{header}           Create Dictionary       Authorization=${token_auth}
    ${response}         PUT on Session         serverest       /produtos/${id_produto}       data=&{payload}                  headers=${header}     expected_status=any
    Log to Console      Novo produto: ${payload}
    Log to Console      Response: ${response.content}  
    Set Global Variable     ${response}

# DELETE KEYWORDS #######################################################################################################
DELETE Endpoint /produtos 
    &{header}           Create Dictionary       Authorization=${token_auth}
    ${response}         DELETE on Session         serverest       /produtos/${id_produto}     headers=${header}          expected_status=any
    Log to Console      Response: ${response.content}  
    Set Global Variable     ${response}

# GENERAL KEYWORDS ###################################################################################################

Coletar ID Produto Aleatorio
    ${response}             GET on Session      serverest   /produtos
    ${numbers}=             Evaluate            random.sample(range(0, ${response.json()["quantidade"]}),1)    random  # Função pega deste post https://stackoverflow.com/questions/22524771/robot-framework-generating-unique-random-number
    ${id_produto}           Set Variable        ${response.json()["produtos"][${numbers}[0]]["_id"]}
    Set Global Variable     ${id_produto}

Definir ID Produto "${id_produto}"
    Set Global Variable     ${id_produto}

Criar Produto
    Fazer Login e Armazenar Token Adm "true"
    Criar Dados para Produto Dinamico Válido
    POST Endpoint /produtos
    Coletar ID Produto

Extrair ID Produto De Carrinho
    ${id_produto}           Set Variable        ${payload["produtos"][0]["idProduto"]}
    Set Global Variable     ${id_produto}

Coletar ID Produto
    ${id_produto}           Set Variable        ${response.json()["_id"]}
    Set Global Variable     ${id_produto}

Pegar Dados Produtos Estatico "${produto}"
    ${json}                 Importar Json Estatico  json_produtos.json
    ${payload}              Set Variable            ${json["${produto}"]}
    log To Console          ${payload}
    Set Global Variable     ${payload}

Alterar "${obj}" Payload Produto
    ${response}             GET on Session      serverest   /produtos/${id_produto}        expected_status=any
    ${nome}                 FakerLibrary.Text            max_nb_chars=25
    ${preco}                FakerLibrary.Random Int      min=20      max=1500
    ${descricao}            FakerLibrary.Text            max_nb_chars=60
    ${quantidade}           FakerLibrary.Random Int      min=2       max=500
    ${payload}              Create Dictionary       nome=${response.json()["nome"]}      preco=${response.json()["preco"]}     descricao=${response.json()["descricao"]}   quantidade=${response.json()["quantidade"]}
    Set to Dictionary       ${payload}               ${obj}=${${obj}}     
    Set Global Variable     ${payload}

Definir "${obj}" = "${valor}" Payload Produto
    ${payload}              Create Dictionary       nome=${payload["nome"]}      preco=${payload["preco"]}     descricao=${payload["descricao"]}   quantidade=${payload["quantidade"]}
    Set to Dictionary       ${payload}              ${obj}=${valor}
    Set Global Variable     ${payload}
    Log To Console          Novo Valor: ${valor}
