#! /bin/bash
# avliable chiper:
# ------------------
# aes-128-cbc       aes-128-ecb       aes-192-cbc       aes-192-ecb       
# aes-256-cbc       aes-256-ecb       base64            bf                
# bf-cbc            bf-cfb            bf-ecb            bf-ofb            
# camellia-128-cbc  camellia-128-ecb  camellia-192-cbc  camellia-192-ecb  
# camellia-256-cbc  camellia-256-ecb  cast              cast-cbc          
# cast5-cbc         cast5-cfb         cast5-ecb         cast5-ofb         
# des               des-cbc           des-cfb           des-ecb           
# des-ede           des-ede-cbc       des-ede-cfb       des-ede-ofb       
# des-ede3          des-ede3-cbc      des-ede3-cfb      des-ede3-ofb      
# des-ofb           des3              desx              idea              
# idea-cbc          idea-cfb          idea-ecb          idea-ofb          
# rc2               rc2-40-cbc        rc2-64-cbc        rc2-cbc           
# rc2-cfb           rc2-ecb           rc2-ofb           rc4               
# rc4-40            seed              seed-cbc          seed-cfb          
# seed-ecb          seed-ofb          zlib
#----------------------------------------------------------------
args=(mode source password)
if (($# != ${#args[@]}));then
    echo "args error!"
    echo "args: ${args[@]}"
    exit 1
fi
AMODE=(e d) # encrypt, decrypt
cipher="aes-256-ecb"
mode="$1"
source="$2"
password="$3"

haha_encrypt()
{
    src="${source}"
    dst="${source}.${cipher}"
    tar -jcf - "${src}" | openssl "${cipher}" -salt -k "${password}" | dd of="${dst}"
}

haha_decrypt()
{
    src="${source}"
    dd if="${src}" | openssl "${cipher}" -d -k "${password}" | tar -xjf -
}

main()
{
    case $mode in
        e)
            haha_encrypt
            ;;
        d)
            haha_decrypt
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
}

# === main ===
if [[ "${BASH_SOURCE[0]}" == "$0" ]];then
    main $*
fi

