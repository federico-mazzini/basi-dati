# accesso a database comune 4CTL
SELECT CONCAT(
    'GRANT SELECT ON `4CTL`.* TO ''',
    User,
    '''@''',
    Host,
    ''';'
) AS grant_stmt
FROM mysql.user
WHERE User LIKE '4CTL\_%';


#verifico permessi di un utente
SELECT User, Host
FROM mysql.user
WHERE User = '4CTL_bonor.t.140308';


# query di aggiunta grant select su db comune 4CTL
localhost:3306/mysql/user/		https://lab.alberghetti.cloud/phpmyadmin/index.php?route=/table/sql&db=mysql&table=user

GRANT SELECT ON `4CTL`.* TO '4CTL_bonor.t.140308'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_calde.e.140908'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_cavin.n.191208'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_ceron.j.051208'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_cosma.l.300908'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_curaj.d.231108'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_de.t.020408'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_haka.o.050508'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_leoni.l.150508'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_manci.m.300608'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_monte.s.141208'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_piero.c.080107'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_poli.f.181007'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_ricci.M.110691'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_santa.A.060704'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_spada.m.221008'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_stefa.M.061007'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_tacco.a.201208'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_tagli.r.041008'@'%';	
GRANT SELECT ON `4CTL`.* TO '4CTL_zotti.r.016908'@'%';	
