<?= '<?xml version="1.0" encoding="UTF-8"?>' ?>
<maniacontrol>
  <server>
    <host><?= getenv('TM_SERVER_NAME') ?></host>
    <port>5000</port>
    <user>SuperAdmin</user>
    <pass>SuperAdmin</pass>
  </server>

  <database>
    <host><?= getenv('MANIACONTROL_DB_HOST') ?></host>
    <port>3306</port>

    <user><?= getenv('MANIACONTROL_DB_USER') ?></user>
    <pass><?= getenv('MANIACONTROL_DB_PASSWORD') ?></pass>

    <name><?= getenv('MANIACONTROL_DB_NAME') ?></name>
  </database>

  <masteradmins>
    <?php foreach (explode(':', getenv('MANIACONTROL_ADMINS')) as $loginId): ?>
    <login><?= $loginId ?></login>
    <?php endforeach ?>
  </masteradmins>
</maniacontrol>
