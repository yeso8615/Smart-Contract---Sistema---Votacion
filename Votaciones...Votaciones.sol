// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 < 0.7.0;
pragma experimental ABIEncoderV2;

// -----------------------------------
//  CANDIDATOS |    EDAD      |    ID
// -----------------------------------
//  Marcos     |    23        |    2816585
//  Joan       |    25        |    9288465
//  Maria      |    35        |    2245868
//  Marta      |    28        |    3286828
//  Alba       |    19        |    5285744


contract votacion{

    //propietario del contrato
    address public owner;

    //constructor
    constructor () public{
        owner = msg.sender;
    }

    //relacion entre en nombre del candidato y el hasd de los datos personales
    mapping(string=>bytes32) ID_Candidatos;

    //relacion entre nombre del candidato y numero de votos
    mapping(string=>uint) Votos_Candidatos;

    //lista para almacenar los nombres de los candidatos
    string[] Candidatos;

    //una lista hash de la identidad de los votantes
    bytes32[] Votantes;

    //cualquier persona pueda usar esta funcion para presentarse a las elecciones
    function Representar(string memory _nombrePersona, uint _edadPersona, string memory _IDPersona) public{

        //hash de los datos del candidato
         bytes32 hash_candidatos = keccak256(abi.encodePacked(_nombrePersona, _edadPersona, _IDPersona));

        //Almacenar el hash de los datos del candidatos ligado a su nombre
        ID_Candidatos[_nombrePersona] = hash_candidatos;

        //Almacenar el nombre del candidato
        Candidatos.push(_nombrePersona);
     
    }

    //Permite visualizar las personas que se presentaron como candidatos a las elecciones  
    function VerCandidatos() public view returns(string[] memory ){
        //devuelve la lista de candidatos presentados
        return Candidatos;

    }

    //los votantes van a poder votar
    function votar(string memory _candidato) public{
        bytes32 hash_votante = keccak256(abi.encodePacked(msg.sender));
        //verificamos si el votante ya ha votado 
            for(uint i=0; i<Votantes.length; i++){
            require(Votantes[i]!=hash_votante, "Ya has votado previamente");
        }
        //almacenamos el hash del votante dentro del array de votantes 
        Votantes.push(hash_votante);
        //Añadimos un voton al candidato seleccionado 
        Votos_Candidatos[_candidato]++;
    }     

    //Dado en el nombre de un candidato nos devuelve el numero de votos que tiene
    function verVotos(string memory _candidato) public view returns(uint){
        //devolviendo el numero de votos del candidato
        return Votos_Candidatos[_candidato];
    }

     //Funcion auxiliar que transforma un uint a un string
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    //ver los votos de cada uno de los candidatos 
    function VerResultados() public view returns (string memory){
        //guardamos en una variable string los candidatos con sus respectivos votos
        string memory resultados;
        //Recorremos el array de candidatos para actualizar el string resultados
        for(uint i=0; i<Candidatos.length; i++){
            //Actualizamos el string resultados y añadimos el candidato que ocupa la posicion "i" del array candidatos
            //y su numero de votos
            resultados = string(abi.encodePacked(resultados, "(", Candidatos[i], ", ", uint2str(verVotos(Candidatos[i])), ") ----"));
        
        }
        //devolvemos los resultados
        return resultados;
    }
    
    //proporcionar el nombre del candidato ganador
    function ganador() public view returns(string memory){
        //la variable ganador ca a contener el nombre del ganador
        string memory ganador=Candidatos[0];
        bool flag;

        //Recorremos el array de candidatos para determinar el candidato con un numero mayor de votos
        for(uint i=1; i<Candidatos.length;i++){

            //Comparamos si nuestro ganador ha sido superado por otro candidato
            if(Votos_Candidatos[ganador] > Votos_Candidatos[Candidatos[i]]){
            ganador = Candidatos[i];
            flag=false;
            }else{
            //Miramos si hay empate entre los candidatos
                if(Votos_Candidatos[ganador]==Votos_Candidatos[Candidatos[i]]){
                    flag=true;
                }

            }
                
        }
        //comprobamos si ha habido un empate entre los candidatos
        if(flag==true){
           //Informamos del empate
        ganador="!Hay un empate entre los candidatos";
        }
        //Devolvemos el ganador
        return ganador;

    }

}
