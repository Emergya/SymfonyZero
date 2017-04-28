<?php

namespace AppBundle\Transformer;

use FOS\ElasticaBundle\Doctrine\AbstractElasticaToModelTransformer;
use Doctrine\ORM\Query;

class ElasticaResultTransformer extends AbstractElasticaToModelTransformer
{
    public function __construct()
    {
      return;
    }

    /**
     * Avoid fetch Doctrine objects
     *
     * @param array $identifierValues ids values
     * @param Boolean $hydrate whether or not to hydrate the objects, false returns arrays
     * @return array of objects or arrays
     */
    protected function findByIdentifiers(array $identifierValues, $hydrate)
    {
      return;
    }

    /**
     *
     * get elastica result sources
     *
     * @param array $elasticaObjects of elastica objects
     *
     * @return array
     **/
    public function transform(array $elasticaObjects)
    {
      return $elasticaObjects;
    }
}
