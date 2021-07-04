// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.6;


contract Securite {
    
    modifier seulementShop(){
        require(msg.sender==0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,"tu n'as pas le droit ");
        _;
    }
    
}

interface A {
    
    
    function creerArticle(string memory _label,uint _prix)external;
    
    
}


  contract AMAZONE is A, Securite {
    
        uint index;
        address  shop=0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
      enum Etatproduit { pret, payer,livrer }
    
            struct Articles {
                
                uint id;
                string label;
                uint prix;
                
                Etatproduit etat;
                
            }
            
            
     mapping(uint =>Articles)public articles;
     event Livrer (uint index,Articles articles,Etatproduit etat);
     event Payement(uint index,uint valeur,address indexed acheteur);
     event Creer(address indexed createur,Articles articles,Etatproduit etat);
     
    function creerArticle(string memory _label,uint _prix)public override seulementShop {
        index+=1;
        articles[index]=Articles(index,_label,_prix*10**18,Etatproduit.pret);
       emit Creer(msg.sender,articles[index],articles[index].etat);
    }
    
    function payement(uint _index)public payable{
        
        require(articles[_index].etat==Etatproduit.pret,"l'article n'est pas pret");
        require(articles[_index].prix==msg.value,"envoyer le montant exact");
        articles[_index].etat=Etatproduit.payer;
     
        payable(shop).transfer(msg.value);
        emit Payement(_index,msg.value,msg.sender);
        
    }
    
      function delivrer(uint _index)public {
        
        require(articles[_index].etat==Etatproduit.payer,"l'article n'est pas paye");
        
        articles[_index].etat=Etatproduit.livrer;
     
        emit Livrer(_index,articles[_index],articles[_index].etat);
    
        
        
    }
   
    
    
}
