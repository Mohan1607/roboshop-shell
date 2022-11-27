STAT(){
  if [ $? -eq 0 ] ; then
    echo -e "\e[32mSUCCESS\e[0m"
    else
      echo -e"\e[31mFAILURE\e[0m"
      exit
  fi
}
PRINT(){
  echo -e "\e[35m$1\E[0m"
}