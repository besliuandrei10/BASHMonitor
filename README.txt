!!! IMPORTANT !!!

Din testele facute de mine, cand sunt create multe procese intr-un interval foarte scurt de timp,
scriptul pare sa se "blocheze". El in actualitate nu se blocheaza dar dintr-un motiv pe care nu il inteleg
sta si se gandeste foarte mult pana incepe sa scrie iar pe terminal.

Nu gasesc o explicatie concreta pentru comportamentul asta, speculez ca este datorat faptului ca asa functioneaza BASH-ul,
din putinul pe care il stiu, BASH este destul de lent ca si limbaj de scripting.

Similar, procese de ~0.13s sau mai putin fie nu sunt identificate deloc, fie sunt vazute decat partial.

Anyway, hope it works! mai jos explic ce face codul mai exact.

!!! SFARSIT IMPORTANT !!!
------------------------------------------------------------------------------------------------------------------------------

### How does it work? ###

Inspirat din tool-urile pe care le-am avut ca model in enunt, scriptul monitorizeaza directorul /proc
pentru aparitii (PID-uri) noi si foloseste comanda ps pentru a afla detalii despre procesul respectiv.

La inceputul rularii, folosind niste parsing creeaza un array old_pids in care stocheaza toate PID-urile din /proc.

Dupa aceia, formeaza un nou array, new_pids, in care avem toate intrarile din /proc de la momentul respectiv. Identificam
care procese nu se regasesc si in old_pids si pe acelea le interogam

Pentru a nu confunda procesele noi cu procesele create de script, acesta ignora toate procesele care au tty-ul identic cu cel
in care a fost rulat scriptul. (varibilele $curr_tty si $proc_tty)

Cand a fost detectat un proces nou, se verifica sa nu fi fost scris deja in log.txt, pentru a evita dublarea
unui proces care a fost captat dar inca este in executie.

Scriptul stie sa primeasca ca si al doilea argument un regex pentru campul cmd.

Pentru a stii cand sa iasa din executie, am folosit comanda date.
