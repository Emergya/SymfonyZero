<?php

namespace AppBundle\Repository;

/**
 * Class UserRepository.
 */
class UserRepository extends BaseRepository
{
	/**
	 * Returns if a user can be searchable or not (for elastic indexing purposes)
	 * 
	 * @param unknown $id
	 * @return boolean
	 */
	public function usersToIndexInElasticSearch($id)
	{
		return true;
	}
}
