* arch-bootstrp
  make

* arch-mini
  cp ../arch-bootstrap/bootstrap/* bootstrap/.
  make
  make dockerhub_push

* archlinux
  make
  make dockerhub_push

* archstrike
  make
  make dockerhub_push
  
  docker run -it archstrike bash 