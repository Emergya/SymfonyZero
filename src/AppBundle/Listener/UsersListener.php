<?php

namespace AppBundle\Listener;

use Symfony\Component\DependencyInjection\ContainerInterface;
use FOS\ElasticaBundle\Doctrine\Listener as BaseListener;
use Doctrine\Common\Persistence\Event\LifecycleEventArgs;
use AppBundle\Entity\User;

/**
 * Class UsersListener
 */
class UsersListener extends BaseListener
{
	protected $container;

	public function setContainer(ContainerInterface $container)
	{
		$this->container = $container;
	}

	/**
	 * Update event (post)
	 *
	 * @param LifecycleEventArgs $args
	 */
	public function postUpdate(LifecycleEventArgs $args)
	{
		$entity = $args->getObject();

		if ($entity instanceof User) {
			$this->scheduledForUpdate[] = $entity;
  		}
	}


	/**
	 * Create event (post)
	 *
	 * @param LifecycleEventArgs $args
	 */
	public function postPersist(LifecycleEventArgs $args) {
		$entity = $args->getObject();

		if ($entity instanceof User) {
			$this->scheduledForUpdate[] = $entity;
		}
	}

	public function onKernelTerminate()	{
    	$this->persistScheduled();
	}


	/**
	* Persist scheduled objects to ElasticSearch
	* After persisting, clear the scheduled queue to prevent multiple data updates when using multiple flush calls.
	*/
	private function persistScheduled() {
		
		if (count($this->scheduledForInsertion)) {
			$this->objectPersister->insertMany($this->scheduledForInsertion);
			$this->scheduledForInsertion = array();
		}

		if (count($this->scheduledForUpdate)) {

			foreach ($this->scheduledForUpdate as $object) {
				//Special condition: if an User comes with null id, we're not doing index update
				if (get_class($object) == 'AppBundle\Entity\User' && $object->getId() == null) {
					unset($this->scheduledForUpdate[array_search($object, $this->scheduledForUpdate)]);
				}
			}

			//Check if scheduledForUpdate array is empty
			if (count($this->scheduledForUpdate)) {
				$this->objectPersister->replaceMany($this->scheduledForUpdate);
				$this->scheduledForUpdate = array();
			}

		}

		if (count($this->scheduledForDeletion)) {
			$this->objectPersister->deleteManyByIdentifiers($this->scheduledForDeletion);
			$this->scheduledForDeletion = array();
		}
	}
}
